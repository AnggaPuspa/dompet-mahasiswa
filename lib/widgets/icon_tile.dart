import 'package:dompet_mahasiswa/theme/app_colors.dart';
import 'package:dompet_mahasiswa/theme/app_radius.dart';
import 'package:dompet_mahasiswa/theme/app_spacing.dart';
import 'package:dompet_mahasiswa/utils/app_assets.dart';
import 'package:dompet_mahasiswa/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    this.extent,
    this.glyphSize,
    this.borderRadius,
  }) : assert(
         variant != null || (icon != null && background != null),
         'IconTile butuh varian, atau ikon beserta latar',
       );

  final IconTileVariant? variant;
  final Widget? icon;
  final Color? background;
  final Color? foreground;
  final double? extent;
  final double? glyphSize;
  final BorderRadius? borderRadius;

  static const double frameExtent = AppSpacing.s24;

  /// Ukuran glyph di dalam tile. Frame Figma Icon/*/14 belum punya token space.
  static const double glyphExtent = 14;

  double get _extent => extent ?? frameExtent;

  double get _glyphExtent => glyphSize ?? glyphExtent;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _background,
        borderRadius: borderRadius ?? AppRadius.smAll,
      ),
      child: SizedBox(
        width: _extent,
        height: _extent,
        child: IconTheme(
          data: IconThemeData(color: _foreground, size: _glyphExtent),
          child: Center(
            child: SizedBox(
              width: _glyphExtent,
              height: _glyphExtent,
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
    final asset = switch (variant!) {
      IconTileVariant.edit => AppAssets.iconPencil,
      IconTileVariant.delete => AppAssets.iconTrash,
    };
    return SvgPicture.asset(
      asset,
      colorFilter: ColorFilter.mode(_foreground, BlendMode.srcIn),
    );
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
    final tile = IconTile(
      variant: variant,
      icon: icon,
      background: background,
      foreground: foreground,
    );
    final button = Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onPressed,
        customBorder: const RoundedRectangleBorder(
          borderRadius: AppRadius.smAll,
        ),
        child: tile,
      ),
    );
    final tip = _tooltip;
    if (tip == null) {
      return button;
    }
    return Tooltip(message: tip, child: button);
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
