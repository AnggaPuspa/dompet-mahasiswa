import 'package:dompet_mahasiswa/theme/app_colors.dart';
import 'package:dompet_mahasiswa/theme/app_radius.dart';
import 'package:dompet_mahasiswa/theme/app_spacing.dart';
import 'package:dompet_mahasiswa/utils/app_strings.dart';
import 'package:flutter/material.dart';

/// Varian tile 24×24 di Figma: Edit (latar lilac) dan Delete (latar danger).
enum IconTileVariant { edit, delete }

/// Kotak ikon 24×24, sudut [AppRadius.sm].
///
/// Varian [IconTileVariant.edit] dan [IconTileVariant.delete] memakai ikon
/// dan warna bawaan. Untuk aksi lain (ikon filter, ikon kategori), isi [icon]
/// dan [background]. Halaman daftar kategori bisa mengganti `_CategoryAction`
/// dengan tile ini, termasuk saat ikonnya masih `Image.asset`.
class IconTile extends StatelessWidget {
  const IconTile({
    super.key,
    this.variant,
    this.icon,
    this.background,
    this.foreground,
  }) : assert(
         variant != null || (icon != null && background != null),
         'IconTile butuh varian, atau ikon beserta latar',
       );

  final IconTileVariant? variant;
  final Widget? icon;
  final Color? background;
  final Color? foreground;

  static const double frameExtent = AppSpacing.s24;

  /// Ukuran glyph di dalam tile. Frame Figma Icon/*/14 belum punya token space.
  static const double glyphExtent = 14;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _background,
        borderRadius: AppRadius.smAll,
      ),
      child: SizedBox(
        width: frameExtent,
        height: frameExtent,
        child: IconTheme(
          data: IconThemeData(color: _foreground, size: glyphExtent),
          child: Center(
            child: SizedBox(
              width: glyphExtent,
              height: glyphExtent,
              child: FittedBox(fit: BoxFit.contain, child: _glyph),
            ),
          ),
        ),
      ),
    );
  }

  Color get _background {
    if (background != null) {
      return background!;
    }
    return switch (variant!) {
      IconTileVariant.edit => AppColors.tintLilac,
      IconTileVariant.delete => AppColors.dangerTint,
    };
  }

  Color get _foreground {
    if (foreground != null) {
      return foreground!;
    }
    return switch (variant!) {
      IconTileVariant.edit => AppColors.primary,
      IconTileVariant.delete => AppColors.danger,
    };
  }

  Widget get _glyph {
    if (icon != null) {
      return icon!;
    }
    return switch (variant!) {
      IconTileVariant.edit => const Icon(Icons.edit_outlined),
      IconTileVariant.delete => const Icon(Icons.delete_outline),
    };
  }
}

/// Tombol ikon untuk AppBar dan aksi kartu.
///
/// Mengganti `IconButton` polos. [onPressed] null membuat tombol nonaktif.
/// Tooltip bawaan varian edit/hapus diambil dari [AppStrings].
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.onPressed,
    this.variant,
    this.tooltip,
    this.icon,
    this.background,
    this.foreground,
  }) : assert(
         variant != null || icon != null,
         'AppIconButton butuh varian atau ikon',
       );

  final VoidCallback? onPressed;
  final IconTileVariant? variant;
  final String? tooltip;
  final Widget? icon;
  final Color? background;
  final Color? foreground;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: _tooltip,
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(
        width: AppSpacing.s32,
        height: AppSpacing.s32,
      ),
      icon: IconTile(
        variant: variant,
        icon: icon,
        background: background,
        foreground: foreground,
      ),
    );
  }

  String? get _tooltip {
    if (tooltip != null) {
      return tooltip;
    }
    return switch (variant) {
      IconTileVariant.edit => AppStrings.ubah,
      IconTileVariant.delete => AppStrings.hapus,
      null => null,
    };
  }
}
