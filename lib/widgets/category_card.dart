import 'package:dompet_mahasiswa/domain/value_objects/jenis_kategori.dart';
import 'package:dompet_mahasiswa/theme/app_colors.dart';
import 'package:dompet_mahasiswa/theme/app_radius.dart';
import 'package:dompet_mahasiswa/theme/app_spacing.dart';
import 'package:dompet_mahasiswa/theme/app_text_styles.dart';
import 'package:dompet_mahasiswa/utils/app_assets.dart';
import 'package:dompet_mahasiswa/utils/app_strings.dart';
import 'package:dompet_mahasiswa/widgets/app_badge.dart';
import 'package:dompet_mahasiswa/widgets/app_card.dart';
import 'package:dompet_mahasiswa/widgets/icon_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Ikon dan latar baris kategori, mengikuti CategoryRow di Figma.
class CategoryCardStyle {
  const CategoryCardStyle({
    required this.asset,
    required this.background,
    required this.foreground,
  });

  final String asset;
  final Color background;
  final Color foreground;

  static const uangSaku = CategoryCardStyle(
    asset: AppAssets.kategoriUang,
    background: AppColors.tintSky,
    foreground: AppColors.accentBlue,
  );
  static const gaji = CategoryCardStyle(
    asset: AppAssets.kategoriGaji,
    background: AppColors.successTint,
    foreground: AppColors.successStrong,
  );
  static const makan = CategoryCardStyle(
    asset: AppAssets.kategoriMakan,
    background: AppColors.tintPink,
    foreground: AppColors.accentPink,
  );
  static const transport = CategoryCardStyle(
    asset: AppAssets.kategoriTransport,
    background: AppColors.tintViolet,
    foreground: AppColors.accentPurple,
  );
  static const kuota = CategoryCardStyle(
    asset: AppAssets.kategoriKuota,
    background: AppColors.tintPeach,
    foreground: AppColors.accentAmber,
  );

  /// Nama contoh di frame Daftar Kategori. Kategori lain jatuh ke jenisnya.
  static const _known = <String, CategoryCardStyle>{
    'Uang Saku': uangSaku,
    'Gaji Part-time': gaji,
    'Makan & Minum': makan,
    'Transportasi': transport,
    'Kuota & Pulsa': kuota,
  };

  static CategoryCardStyle forCategory(String nama, String jenis) {
    return _known[nama] ??
        (jenis == JenisKategori.pemasukan.value ? gaji : makan);
  }
}

/// Kartu satu kategori. Tata letaknya sama untuk setiap pemakaian.
class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.name,
    required this.jenis,
    required this.style,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.margin = EdgeInsets.zero,
  });

  final String name;
  final String jenis;
  final CategoryCardStyle style;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final EdgeInsetsGeometry margin;

  /// Sisi tile ikon di CategoryRow. Bukan token jarak.
  static const double tileExtent = 34;

  @override
  Widget build(BuildContext context) {
    final income = jenis == JenisKategori.pemasukan.value;
    return AppCard(
      onTap: onTap,
      margin: margin,
      padding: AppSpacing.pad16,
      child: Row(
        children: [
          IconTile(
            icon: SvgPicture.asset(
              style.asset,
              colorFilter: ColorFilter.mode(style.foreground, BlendMode.srcIn),
            ),
            background: style.background,
            foreground: style.foreground,
            extent: tileExtent,
            glyphSize: AppSpacing.s20,
            borderRadius: AppRadius.tileAll,
          ),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.body),
                const SizedBox(height: AppSpacing.s4),
                AppBadge(
                  label: income ? AppStrings.pemasukan : AppStrings.pengeluaran,
                  jenis: jenis,
                ),
              ],
            ),
          ),
          AppIconButton(variant: IconTileVariant.edit, onPressed: onEdit),
          const SizedBox(width: AppSpacing.s8),
          AppIconButton(variant: IconTileVariant.delete, onPressed: onDelete),
        ],
      ),
    );
  }
}
