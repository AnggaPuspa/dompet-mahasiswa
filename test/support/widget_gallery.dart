import 'package:dompet_mahasiswa/domain/value_objects/jenis_kategori.dart';
import 'package:dompet_mahasiswa/theme/app_colors.dart';
import 'package:dompet_mahasiswa/theme/app_spacing.dart';
import 'package:dompet_mahasiswa/utils/app_strings.dart';
import 'package:dompet_mahasiswa/utils/currency_format.dart';
import 'package:dompet_mahasiswa/utils/date_format.dart';
import 'package:dompet_mahasiswa/widgets/app_badge.dart';
import 'package:dompet_mahasiswa/widgets/app_dropdown_form_field.dart';
import 'package:dompet_mahasiswa/widgets/app_filter_chip.dart';
import 'package:dompet_mahasiswa/widgets/hero_card.dart';
import 'package:dompet_mahasiswa/widgets/icon_tile.dart';
import 'package:dompet_mahasiswa/widgets/periode_chips.dart';
import 'package:dompet_mahasiswa/widgets/periode_menu.dart';
import 'package:dompet_mahasiswa/widgets/summary_card.dart';
import 'package:dompet_mahasiswa/widgets/transaction_card.dart';
import 'package:dompet_mahasiswa/widgets/wallet_card.dart';
import 'package:flutter/material.dart';

/// Susunan widget global untuk ditinjau di tes. Bukan halaman aplikasi.
class WidgetGallery extends StatelessWidget {
  const WidgetGallery({super.key});

  @override
  Widget build(BuildContext context) {
    final tanggal = formatTanggal(DateTime(2026, 11, 23));
    return ColoredBox(
      color: AppColors.primaryTint,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(AppStrings.appName),
            const SizedBox(height: AppSpacing.s16),
            HeroCard(
              caption: AppStrings.pengeluaranBulanIni,
              line1: AppStrings.pemasukan,
              line2: AppStrings.pengeluaran,
              buttonLabel: AppStrings.lihatRiwayat,
              percent: 42,
              onButtonPressed: () {},
            ),
            const SizedBox(height: AppSpacing.s16),
            SummaryCard(
              label: AppStrings.totalSaldo,
              amount: formatRupiah(0),
              info: AppStrings.pemasukanBulanIni,
            ),
            const SizedBox(height: AppSpacing.s16),
            Row(
              children: [
                _wallet(WalletCardVariant.blue),
                const SizedBox(width: AppSpacing.s12),
                _wallet(WalletCardVariant.orange),
                const SizedBox(width: AppSpacing.s12),
                _wallet(WalletCardVariant.pink),
              ],
            ),
            const SizedBox(height: AppSpacing.s16),
            TransactionCard(
              jenis: JenisKategori.pemasukan.value,
              title: AppStrings.kategori,
              subtitle: AppStrings.dompet,
              dateLabel: tanggal,
              jumlah: 10000,
            ),
            const SizedBox(height: AppSpacing.s12),
            TransactionCard(
              jenis: JenisKategori.pengeluaran.value,
              title: AppStrings.kategori,
              subtitle: AppStrings.dompet,
              dateLabel: tanggal,
              jumlah: 20000,
            ),
            const SizedBox(height: AppSpacing.s16),
            const Row(
              children: [
                AppBadge(label: AppStrings.pemasukan, jenis: 'Pemasukan'),
                SizedBox(width: AppSpacing.s8),
                AppBadge(label: AppStrings.pengeluaran, jenis: 'Pengeluaran'),
                SizedBox(width: AppSpacing.s8),
                AppBadge(
                  label: '3',
                  foreground: AppColors.primary,
                  background: AppColors.tintLilac,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s16),
            const Row(
              children: [
                IconTile(variant: IconTileVariant.edit),
                SizedBox(width: AppSpacing.s8),
                IconTile(variant: IconTileVariant.delete),
                AppIconButton(variant: IconTileVariant.edit, onPressed: _noop),
                AppIconButton(
                  variant: IconTileVariant.delete,
                  onPressed: _noop,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s16),
            AppFilterChipBar<JenisKategori?>(
              selected: JenisKategori.pemasukan,
              onSelected: (_) {},
              options: const [
                AppFilterOption(value: null, label: AppStrings.semua),
                AppFilterOption(
                  value: JenisKategori.pemasukan,
                  label: AppStrings.pemasukan,
                ),
                AppFilterOption(
                  value: JenisKategori.pengeluaran,
                  label: AppStrings.pengeluaran,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s16),
            PeriodeChips(
              periode: Periode.bulanan,
              selectedId: '2026-11',
              onSelected: (_) {},
              items: [
                PeriodeChipData(
                  id: '2026-09',
                  top: '2026',
                  main: 'Sep',
                  bottom: AppStrings.jumlahTransaksi(9),
                ),
                PeriodeChipData(
                  id: '2026-10',
                  top: '2026',
                  main: 'Okt',
                  bottom: AppStrings.jumlahTransaksi(14),
                ),
                PeriodeChipData(
                  id: '2026-11',
                  top: '2026',
                  main: 'Nov',
                  bottom: AppStrings.jumlahTransaksi(6),
                ),
                PeriodeChipData(
                  id: '2026-12',
                  top: '2026',
                  main: 'Des',
                  bottom: AppStrings.jumlahTransaksi(0),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s16),
            const PeriodeMenu(selected: Periode.bulanan, onSelected: _periode),
            const SizedBox(height: AppSpacing.s16),
            SizedBox(
              width: AppDropdownFormField.frameWidth,
              child: AppDropdownFormField<JenisKategori>(
                label: AppStrings.jenis,
                initialValue: JenisKategori.pengeluaran,
                onChanged: (_) {},
                icon: const Icon(Icons.category_outlined),
                options: const {
                  JenisKategori.pemasukan: AppStrings.pemasukan,
                  JenisKategori.pengeluaran: AppStrings.pengeluaran,
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  WalletCard _wallet(WalletCardVariant variant) {
    return WalletCard(
      variant: variant,
      label: AppStrings.dompet,
      name: AppStrings.dompet,
      amount: formatRupiah(0),
      progress: 0.55,
    );
  }
}

void _noop() {}

void _periode(Periode _) {}
