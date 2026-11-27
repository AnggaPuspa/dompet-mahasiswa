import 'package:dompet_mahasiswa/theme/app_colors.dart';
import 'package:dompet_mahasiswa/theme/app_spacing.dart';
import 'package:dompet_mahasiswa/utils/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Lonceng 24×24 dengan titik badge 8×8 di pojok kanan atas.
///
/// Warna ikon dan titik mengikuti frame pemanggil. Dashboard memakai
/// primary dan pink; header kategori memakai teks dan primary.
class AppNotificationButton extends StatelessWidget {
  const AppNotificationButton({
    super.key,
    this.color = AppColors.text,
    this.badgeColor = AppColors.primary,
    this.onPressed,
  });

  final Color color;
  final Color badgeColor;
  final VoidCallback? onPressed;

  static const double badgeExtent = AppSpacing.s8;

  /// Jarak kiri titik di frame Figma. Bukan token jarak.
  static const double badgeLeft = 13;

  @override
  Widget build(BuildContext context) {
    final bell = SizedBox(
      width: AppSpacing.s24,
      height: AppSpacing.s24,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SvgPicture.asset(
            AppAssets.notification,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
          Positioned(
            left: badgeLeft,
            top: 0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: badgeColor,
                shape: BoxShape.circle,
              ),
              child: const SizedBox(width: badgeExtent, height: badgeExtent),
            ),
          ),
        ],
      ),
    );
    if (onPressed == null) {
      return bell;
    }
    return InkWell(
      onTap: onPressed,
      customBorder: const CircleBorder(),
      child: bell,
    );
  }
}
