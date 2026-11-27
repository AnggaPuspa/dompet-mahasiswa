import 'dart:math' as math;

import 'package:dompet_mahasiswa/database/database_helper.dart';
import 'package:dompet_mahasiswa/theme/app_colors.dart';
import 'package:dompet_mahasiswa/theme/app_spacing.dart';
import 'package:dompet_mahasiswa/theme/app_text_styles.dart';
import 'package:dompet_mahasiswa/utils/app_strings.dart';
import 'package:dompet_mahasiswa/utils/currency_format.dart';
import 'package:dompet_mahasiswa/utils/date_format.dart';
import 'package:dompet_mahasiswa/utils/snackbar_helper.dart';
import 'package:dompet_mahasiswa/widgets/app_badge.dart';
import 'package:dompet_mahasiswa/widgets/app_card.dart';
import 'package:dompet_mahasiswa/widgets/empty_state.dart';
import 'package:dompet_mahasiswa/widgets/hero_card.dart';
import 'package:dompet_mahasiswa/widgets/icon_tile.dart';
import 'package:dompet_mahasiswa/widgets/wallet_card.dart';
import 'package:flutter/material.dart';

/// Ringkasan saldo, arus bulan ini, dan tiga kategori pengeluaran terbesar.
///
/// Angka datang dari [DatabaseHelper]. Halaman tidak menjumlah saldo sendiri.
class DashboardPage extends StatefulWidget {
  const DashboardPage({
    super.key,
    this.isActive = true,
    this.onLihatRiwayat,
    this.onOpenDompet,
  });

  /// False saat tab lain yang sedang tampil. Data dimuat ulang
  /// ketika nilai ini berubah dari false menjadi true.
  final bool isActive;

  final VoidCallback? onLihatRiwayat;
  final VoidCallback? onOpenDompet;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DatabaseHelper _database = DatabaseHelper.instance;

  _DashboardSnapshot? _data;
  var _loading = true;
  var _error = false;
  var _generation = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant DashboardPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _load();
    }
  }

  Future<void> _load() async {
    final generation = ++_generation;
    final showSpinner = _data == null;
    setState(() {
      _error = false;
      if (showSpinner) {
        _loading = true;
      }
    });
    try {
      final snapshot = await _ambil();
      if (!mounted || generation != _generation) {
        return;
      }
      setState(() {
        _data = snapshot;
        _loading = false;
        _error = false;
      });
    } catch (_) {
      if (!mounted || generation != _generation) {
        return;
      }
      setState(() {
        _data = null;
        _loading = false;
        _error = true;
      });
      showErrorSnackbar(context, AppStrings.gagalMemuatDashboard);
    }
  }

  Future<_DashboardSnapshot> _ambil() async {
    final sekarang = DateTime.now();
    final bulan = toYearMonth(sekarang);
    final totalSaldo = await _database.getTotalSaldoSemuaDompet();
    final pemasukan = await _database.getTotalPemasukanBulan(bulan);
    final pengeluaran = await _database.getTotalPengeluaranBulan(bulan);
    final terbesar = await _database.getTopKategoriPengeluaranBulan(
      bulan,
      limit: 3,
    );
    final dompet = await _database.getAllDompet();
    final transaksi = await _database.getAllTransaksi();

    // Hitungan baris untuk label kartu, bukan rumus saldo.
    final jumlah = <int, int>{};
    for (final item in transaksi) {
      jumlah[item.dompetId] = (jumlah[item.dompetId] ?? 0) + 1;
    }

    final ringkas = <_DompetRingkas>[];
    for (final item in dompet) {
      final id = item.id;
      final saldo = id == null ? 0 : await _database.getSaldoDompet(id);
      ringkas.add(
        _DompetRingkas(
          nama: item.nama,
          saldo: saldo,
          jumlahTransaksi: id == null ? 0 : jumlah[id] ?? 0,
        ),
      );
    }

    return _DashboardSnapshot(
      totalSaldo: totalSaldo,
      pemasukan: pemasukan,
      pengeluaran: pengeluaran,
      terbesar: terbesar,
      dompet: ringkas,
      kosong: dompet.isEmpty && transaksi.isEmpty,
      bulan: sekarang,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        minimum: const EdgeInsets.only(top: AppSpacing.s28),
        child: _body(),
      ),
    );
  }

  Widget _body() {
    if (_loading && _data == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error || _data == null) {
      return EmptyState(
        title: AppStrings.gagalMemuatDashboard,
        actionLabel: AppStrings.cobaLagi,
        onAction: _load,
      );
    }
    final data = _data!;
    if (data.kosong) {
      return const EmptyState(
        title: AppStrings.belumAdaData,
        message: AppStrings.pesanDashboardKosong,
      );
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: _DashboardBody(
        data: data,
        onLihatRiwayat: widget.onLihatRiwayat,
        onOpenDompet: widget.onOpenDompet,
      ),
    );
  }
}

class _DashboardSnapshot {
  const _DashboardSnapshot({
    required this.totalSaldo,
    required this.pemasukan,
    required this.pengeluaran,
    required this.terbesar,
    required this.dompet,
    required this.kosong,
    required this.bulan,
  });

  final int totalSaldo;
  final int pemasukan;
  final int pengeluaran;
  final List<({int kategoriId, String nama, int total})> terbesar;
  final List<_DompetRingkas> dompet;
  final bool kosong;
  final DateTime bulan;
}

class _DompetRingkas {
  const _DompetRingkas({
    required this.nama,
    required this.saldo,
    required this.jumlahTransaksi,
  });

  final String nama;
  final int saldo;
  final int jumlahTransaksi;
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({
    required this.data,
    required this.onLihatRiwayat,
    required this.onOpenDompet,
  });

  final _DashboardSnapshot data;
  final VoidCallback? onLihatRiwayat;
  final VoidCallback? onOpenDompet;

  @override
  Widget build(BuildContext context) {
    final bulan = formatBulanTahunPendek(data.bulan);
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s22,
        0,
        AppSpacing.s22,
        AppSpacing.s24,
      ),
      children: [
        const _Header(),
        const SizedBox(height: AppSpacing.s24),
        SizedBox(
          height: HeroCard.frameHeight,
          width: double.infinity,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: HeroCard(
              caption: AppStrings.budgetTerpakaiBulan(bulan),
              line1: AppStrings.labelNominal(
                AppStrings.pemasukan,
                formatRupiah(data.pemasukan),
              ),
              line2: AppStrings.labelNominal(
                AppStrings.pengeluaran,
                formatRupiah(data.pengeluaran),
              ),
              buttonLabel: AppStrings.lihatRiwayat,
              percent: _persen(data.pengeluaran, data.pemasukan),
              onButtonPressed: onLihatRiwayat,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.s24),
        _SectionTitle(
          title: AppStrings.dompetSaya,
          count: data.dompet.length,
          action: AppStrings.totalNominal(formatRupiah(data.totalSaldo)),
        ),
        const SizedBox(height: AppSpacing.s16),
        if (data.dompet.isEmpty)
          Text(
            AppStrings.belumAdaDompet,
            style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
          )
        else
          SizedBox(
            key: const Key('daftar-dompet'),
            height: WalletCard.frameHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: data.dompet.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(width: AppSpacing.s16),
              itemBuilder: (context, index) {
                final dompet = data.dompet[index];
                return WalletCard(
                  variant: WalletCardVariant
                      .values[index % WalletCardVariant.values.length],
                  label: AppStrings.jumlahTransaksiDompet(
                    dompet.jumlahTransaksi,
                  ),
                  name: dompet.nama,
                  amount: formatRupiah(dompet.saldo),
                  progress: _porsi(dompet.saldo, data.totalSaldo),
                  onTap: onOpenDompet,
                );
              },
            ),
          ),
        const SizedBox(height: AppSpacing.s24),
        _SectionTitle(
          title: AppStrings.pengeluaranTerbesarBulanIni,
          count: data.terbesar.length,
          action: bulan,
        ),
        const SizedBox(height: AppSpacing.s16),
        if (data.terbesar.isEmpty)
          const AppCard(
            child: Text(
              AppStrings.belumAdaPengeluaranBulanIni,
              style: AppTextStyles.body,
            ),
          )
        else
          for (var i = 0; i < data.terbesar.length; i++)
            _CategoryRow(
              nama: data.terbesar[i].nama,
              total: data.terbesar[i].total,
              percent: _persen(data.terbesar[i].total, data.pengeluaran),
              gaya: _gayaKategori[i % _gayaKategori.length],
            ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  /// Diameter avatar di frame Header/Dashboard. Belum ada token jarak.
  static const double _avatarExtent = 46;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DecoratedBox(
          decoration: const BoxDecoration(
            color: AppColors.tintViolet,
            shape: BoxShape.circle,
          ),
          child: SizedBox(
            width: _avatarExtent,
            height: _avatarExtent,
            child: Center(
              child: Text(
                AppStrings.inisialTampilan,
                style: AppTextStyles.bodyStrong.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.s16),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.sapaan, style: AppTextStyles.body),
              SizedBox(height: AppSpacing.s4),
              Text(
                AppStrings.namaTampilan,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.heading19,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.s12),
        const _Bell(),
      ],
    );
  }
}

class _Bell extends StatelessWidget {
  const _Bell();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.s24,
      height: AppSpacing.s24,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(
            Icons.notifications_rounded,
            color: AppColors.primary,
            size: AppSpacing.s24,
          ),
          Positioned(
            right: 0,
            top: 0,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: AppColors.accentPink,
                shape: BoxShape.circle,
              ),
              child: SizedBox(width: AppSpacing.s8, height: AppSpacing.s8),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.count,
    required this.action,
  });

  final String title;
  final int count;
  final String action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.heading19,
                ),
              ),
              const SizedBox(width: AppSpacing.s6),
              AppBadge(
                label: '$count',
                foreground: AppColors.primary,
                background: AppColors.primaryTint,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.s8),
        Text(
          action,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodyStrong.copyWith(color: AppColors.primary),
        ),
      ],
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({
    required this.nama,
    required this.total,
    required this.percent,
    required this.gaya,
  });

  final String nama;
  final int total;
  final int percent;
  final _GayaKategori gaya;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.s16),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
        vertical: AppSpacing.s12,
      ),
      child: Row(
        children: [
          IconTile(
            icon: Icon(gaya.icon),
            background: gaya.background,
            foreground: gaya.foreground,
          ),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nama,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body,
                ),
                const SizedBox(height: AppSpacing.s2),
                Text(
                  AppStrings.nominalBulanIni(formatRupiah(total)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.s12),
          _PercentRing(percent: percent, color: gaya.foreground),
        ],
      ),
    );
  }
}

class _GayaKategori {
  const _GayaKategori(this.icon, this.background, this.foreground);

  final IconData icon;
  final Color background;
  final Color foreground;
}

// Kategori tidak menyimpan ikon. Tiga gaya ini mengikuti baris contoh
// di frame Dashboard dan berulang bila barisnya lebih dari tiga.
const _gayaKategori = <_GayaKategori>[
  _GayaKategori(
    Icons.restaurant_rounded,
    AppColors.tintPink,
    AppColors.accentPink,
  ),
  _GayaKategori(
    Icons.directions_bus_rounded,
    AppColors.tintViolet,
    AppColors.accentPurple,
  ),
  _GayaKategori(
    Icons.smartphone_rounded,
    AppColors.tintPeach,
    AppColors.accentAmber,
  ),
];

class _PercentRing extends StatelessWidget {
  const _PercentRing({required this.percent, required this.color});

  final int percent;
  final Color color;

  /// Diameter cincin baris kategori di frame Dashboard. Bukan token jarak.
  static const double extent = 42;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: extent,
      height: extent,
      child: CustomPaint(
        painter: _RingPainter(percent: percent, color: color),
        child: Center(
          child: Text(
            '$percent%',
            style: AppTextStyles.caption.copyWith(color: AppColors.text),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({required this.percent, required this.color});

  final int percent;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = AppSpacing.s4;
    final arc = (Offset.zero & size).deflate(stroke / 2);
    final track = Paint()
      ..color = AppColors.outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(arc, 0, math.pi * 2, false, track);
    if (percent == 0) {
      return;
    }
    final progress = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      arc,
      -math.pi / 2,
      math.pi * 2 * percent / 100,
      false,
      progress,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.percent != percent || oldDelegate.color != color;
  }
}

int _persen(int bagian, int seluruh) {
  if (bagian <= 0 || seluruh <= 0) {
    return 0;
  }
  final hasil = (bagian * 100 / seluruh).round();
  if (hasil > 100) {
    return 100;
  }
  return hasil;
}

double _porsi(int saldo, int total) {
  if (saldo <= 0 || total <= 0) {
    return 0;
  }
  final nilai = saldo / total;
  if (nilai > 1) {
    return 1;
  }
  return nilai;
}
