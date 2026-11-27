import 'package:dompet_mahasiswa/domain/value_objects/jenis_kategori.dart';
import 'package:dompet_mahasiswa/theme/app_colors.dart';
import 'package:dompet_mahasiswa/theme/app_radius.dart';
import 'package:dompet_mahasiswa/theme/app_shadows.dart';
import 'package:dompet_mahasiswa/theme/app_spacing.dart';
import 'package:dompet_mahasiswa/theme/app_text_styles.dart';
import 'package:dompet_mahasiswa/utils/app_strings.dart';
import 'package:dompet_mahasiswa/utils/color_helper.dart';
import 'package:dompet_mahasiswa/utils/currency_format.dart';
import 'package:dompet_mahasiswa/widgets/app_badge.dart';
import 'package:dompet_mahasiswa/widgets/icon_tile.dart';
import 'package:flutter/material.dart';

/// Kartu transaksi 331×94, sudut [AppRadius.md], bayangan [AppShadows.card].
///
/// [jumlah] selalu positif. Tanda +/− mengikuti [jenis]
/// (`'Pemasukan'` atau `'Pengeluaran'`), lewat [formatRupiah].
/// Warna nominal dan badge memakai [colorForJenis] / [backgroundForJenis].
/// [dateLabel] sudah diformat pemanggil, misalnya lewat formatTanggal.
class TransactionCard extends StatelessWidget {
  const TransactionCard({
    super.key,
    required this.jenis,
    required this.title,
    required this.subtitle,
    required this.dateLabel,
    required this.jumlah,
    this.icon,
    this.onTap,
  });

  final String jenis;
  final String title;
  final String subtitle;
  final String dateLabel;
  final int jumlah;
  final Widget? icon;
  final VoidCallback? onTap;

  static const double frameWidth = 331;
  static const double frameHeight = 94;

  @override
  Widget build(BuildContext context) {
    final jenisWarna = colorForJenis(jenis);
    return SizedBox(
      width: frameWidth,
      height: frameHeight,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.mdAll,
          boxShadow: AppShadows.card,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppRadius.mdAll,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.s16,
                AppSpacing.s12,
                AppSpacing.s12,
                AppSpacing.s16,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _Left(
                      subtitle: subtitle,
                      title: title,
                      dateLabel: dateLabel,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s8),
                  _Right(
                    jenis: jenis,
                    jumlahTeks: _jumlahTeks,
                    badgeLabel: _badgeLabel,
                    icon: icon,
                    warna: jenisWarna,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String get _jumlahTeks {
    final nominal = formatRupiah(jumlah.abs());
    return switch (JenisKategori.parse(jenis)) {
      JenisKategori.pemasukan => '+$nominal',
      JenisKategori.pengeluaran => '-$nominal',
    };
  }

  String get _badgeLabel {
    return switch (JenisKategori.parse(jenis)) {
      JenisKategori.pemasukan => AppStrings.pemasukan,
      JenisKategori.pengeluaran => AppStrings.pengeluaran,
    };
  }
}

class _Left extends StatelessWidget {
  const _Left({
    required this.subtitle,
    required this.title,
    required this.dateLabel,
  });

  final String subtitle;
  final String title;
  final String dateLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.s4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: AppSpacing.s8),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body,
          ),
          const SizedBox(height: AppSpacing.s8),
          Row(
            children: [
              const Icon(
                Icons.access_time_filled,
                size: IconTile.glyphExtent,
                color: AppColors.primarySoft,
              ),
              const SizedBox(width: AppSpacing.s6),
              Flexible(
                child: Text(
                  dateLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primarySoft,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Right extends StatelessWidget {
  const _Right({
    required this.jenis,
    required this.jumlahTeks,
    required this.badgeLabel,
    required this.icon,
    required this.warna,
  });

  final String jenis;
  final String jumlahTeks;
  final String badgeLabel;
  final Widget? icon;
  final Color warna;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        IconTile(
          icon: icon ?? const Icon(Icons.receipt_outlined),
          background: _tileBackground,
          foreground: warna,
        ),
        Text(
          jumlahTeks,
          style: AppTextStyles.bodyStrong.copyWith(color: warna),
        ),
        AppBadge(label: badgeLabel, jenis: jenis),
      ],
    );
  }

  Color get _tileBackground {
    return switch (JenisKategori.parse(jenis)) {
      JenisKategori.pemasukan => AppColors.tintLilac,
      JenisKategori.pengeluaran => AppColors.tintPink,
    };
  }
}
