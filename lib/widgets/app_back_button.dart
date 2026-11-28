import 'package:dompet_mahasiswa/theme/app_colors.dart';
import 'package:dompet_mahasiswa/theme/app_spacing.dart';
import 'package:dompet_mahasiswa/utils/app_assets.dart';
import 'package:dompet_mahasiswa/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Tombol kembali dengan ikon Iconly Bold Arrow-Left.
///
/// Dipakai sebagai leading di setiap halaman yang bisa kembali.
/// Warna ikon [AppColors.icon], bukan panah Material.
class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.onPressed, this.enabled = true});

  /// Kalau null dan [enabled], halaman ditutup dengan [Navigator.maybePop].
  final VoidCallback? onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: AppStrings.kembali,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: enabled
              ? (onPressed ?? () => Navigator.maybePop(context))
              : null,
          customBorder: const CircleBorder(),
          child: SvgPicture.asset(
            AppAssets.arrowLeft,
            width: AppSpacing.s24,
            height: AppSpacing.s24,
            colorFilter: const ColorFilter.mode(
              AppColors.icon,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
