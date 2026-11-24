import 'package:dompet_mahasiswa/theme/app_colors.dart';
import 'package:dompet_mahasiswa/theme/app_radius.dart';
import 'package:dompet_mahasiswa/theme/app_spacing.dart';
import 'package:dompet_mahasiswa/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

enum AppButtonVariant { primary, secondary, danger }

// Satu tombol untuk seluruh aplikasi. Lebar 331 dan tinggi 52
// mengikuti frame Figma, bukan token jarak.
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

  static const double frameWidth = 331;
  static const double frameHeight = 52;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isLoading;
    final child = isLoading
        ? SizedBox(
            height: AppSpacing.s24,
            width: AppSpacing.s24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
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

    final button = Material(
      color: _background(enabled),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.buttonAll,
        side: variant == AppButtonVariant.secondary
            ? const BorderSide(color: AppColors.outline)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: AppRadius.buttonAll,
        child: SizedBox(
          height: frameHeight,
          width: isExpanded ? frameWidth : null,
          child: Center(child: child),
        ),
      ),
    );

    if (!isExpanded) {
      return button;
    }
    return Align(alignment: Alignment.center, child: button);
  }

  Color _background(bool enabled) {
    if (!enabled) {
      return AppColors.outline;
    }
    return switch (variant) {
      AppButtonVariant.primary => AppColors.primary,
      AppButtonVariant.secondary => AppColors.surface,
      AppButtonVariant.danger => AppColors.danger,
    };
  }

  Color _foreground(bool enabled) {
    if (!enabled) {
      return AppColors.textMuted;
    }
    return switch (variant) {
      AppButtonVariant.primary => AppColors.onPrimary,
      AppButtonVariant.secondary => AppColors.text,
      AppButtonVariant.danger => AppColors.onPrimary,
    };
  }
}
