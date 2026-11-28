import 'dart:ui';

import 'package:dompet_mahasiswa/theme/app_colors.dart';
import 'package:dompet_mahasiswa/theme/app_radius.dart';
import 'package:dompet_mahasiswa/theme/app_shadows.dart';
import 'package:dompet_mahasiswa/theme/app_spacing.dart';
import 'package:dompet_mahasiswa/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

enum AppButtonVariant { primary, secondary, danger }

/// Elips ungu yang di-blur di bawah tombol primer.
class _ButtonGlow extends StatelessWidget {
  const _ButtonGlow();

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(
        sigmaX: AppShadows.glowBlurSigma,
        sigmaY: AppShadows.glowBlurSigma,
      ),
      child: const Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          height: AppShadows.glowHeight,
          width: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: AppRadius.fullAll,
            ),
          ),
        ),
      ),
    );
  }
}

/// Satu tombol untuk seluruh aplikasi.
///
/// Tinggi 52 dan sudut [AppRadius.button]. Lebar mengisi induk kalau
/// [isExpanded]. Varian primer membawa glow ungu di bawah tombol.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.isExpanded = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final Widget? icon;
  final bool isExpanded;

  /// Lebar frame Figma di layar 375. Tombol mengisi induk, bukan dipotong di sini.
  static const double frameWidth = 331;
  static const double frameHeight = 52;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isLoading;
    final button = _face(enabled);
    if (!enabled || variant != AppButtonVariant.primary) {
      return button;
    }
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: AppSpacing.s12,
          right: AppShadows.glowInsetEnd,
          bottom: -(AppShadows.glowDrop + AppShadows.glowBleed),
          height: AppShadows.glowHeight + AppShadows.glowBleed,
          child: const IgnorePointer(child: _ButtonGlow()),
        ),
        button,
      ],
    );
  }

  Widget _face(bool enabled) {
    final child = isLoading
        ? SizedBox(
            height: AppSpacing.s24,
            width: AppSpacing.s24,
            child: CircularProgressIndicator(
              strokeWidth: AppSpacing.s2,
              color: _foreground(enabled),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                IconTheme(
                  data: IconThemeData(color: _foreground(enabled)),
                  child: icon!,
                ),
                const SizedBox(width: AppSpacing.s8),
              ],
              Text(
                label,
                style: AppTextStyles.heading19.copyWith(
                  color: _foreground(enabled),
                ),
              ),
            ],
          );

    return Material(
      color: _background(enabled),
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.buttonAll),
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: AppRadius.buttonAll,
        child: SizedBox(
          height: frameHeight,
          width: isExpanded ? double.infinity : null,
          child: Center(child: child),
        ),
      ),
    );
  }

  Color _background(bool enabled) {
    if (!enabled) {
      return AppColors.outline;
    }
    return switch (variant) {
      AppButtonVariant.primary => AppColors.primary,
      AppButtonVariant.secondary => AppColors.tintLilac,
      AppButtonVariant.danger => AppColors.danger,
    };
  }

  Color _foreground(bool enabled) {
    if (!enabled) {
      return AppColors.textMuted;
    }
    return switch (variant) {
      AppButtonVariant.primary => AppColors.onPrimary,
      AppButtonVariant.secondary => AppColors.primary,
      AppButtonVariant.danger => AppColors.onPrimary,
    };
  }
}
