import 'package:dompet_mahasiswa/theme/app_colors.dart';
import 'package:dompet_mahasiswa/theme/app_radius.dart';
import 'package:dompet_mahasiswa/theme/app_shadows.dart';
import 'package:dompet_mahasiswa/theme/app_spacing.dart';
import 'package:dompet_mahasiswa/theme/app_text_styles.dart';
import 'package:dompet_mahasiswa/utils/app_strings.dart';
import 'package:dompet_mahasiswa/widgets/app_button.dart';
import 'package:flutter/material.dart';

/// Dialog/Konfirmasi Hapus, konfirmasi biasa, dan Dialog/Info.
enum ConfirmDialogVariant { danger, primary, info }

/// Dialog konfirmasi. Batal atau tutup di luar mengembalikan false.
/// Tombol konfirmasi, termasuk "Mengerti" pada varian info, mengembalikan true.
abstract final class ConfirmDialog {
  /// Lebar frame Figma Dialog (311). Bukan token jarak.
  static const double frameWidth = 311;

  /// Lingkaran ikon di Figma (56). Bukan token jarak.
  static const double iconBadgeExtent = 56;

  /// Scrim Figma memakai color/text pada 45%.
  static const double scrimOpacity = 0.45;

  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    String? confirmLabel,
    String cancelLabel = AppStrings.batal,
    bool isDanger = true,
    ConfirmDialogVariant? variant,
  }) async {
    final resolved =
        variant ??
        (isDanger ? ConfirmDialogVariant.danger : ConfirmDialogVariant.primary);
    final confirmText =
        confirmLabel ??
        (resolved == ConfirmDialogVariant.info
            ? AppStrings.mengerti
            : AppStrings.hapus);
    final result = await showDialog<bool>(
      context: context,
      barrierColor: AppColors.text.withValues(alpha: scrimOpacity),
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s32,
            vertical: AppSpacing.s24,
          ),
          child: _ConfirmDialogBody(
            title: title,
            message: message,
            confirmLabel: confirmText,
            cancelLabel: cancelLabel,
            variant: resolved,
          ),
        );
      },
    );
    return result ?? false;
  }
}

class _ConfirmDialogBody extends StatelessWidget {
  const _ConfirmDialogBody({
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.variant,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final ConfirmDialogVariant variant;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: ConfirmDialog.frameWidth),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.xlAll,
          boxShadow: AppShadows.card,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Badge(variant: variant),
              const SizedBox(height: AppSpacing.s16),
              Text(title, style: AppTextStyles.h2, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.s16),
              Text(
                message,
                style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.s16),
              _actions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actions(BuildContext context) {
    final confirm = AppButton(
      label: confirmLabel,
      variant: variant == ConfirmDialogVariant.danger
          ? AppButtonVariant.danger
          : AppButtonVariant.primary,
      onPressed: () => Navigator.pop(context, true),
    );
    if (variant == ConfirmDialogVariant.info) {
      return confirm;
    }
    return Row(
      children: [
        Expanded(
          child: AppButton(
            label: cancelLabel,
            variant: AppButtonVariant.secondary,
            onPressed: () => Navigator.pop(context, false),
          ),
        ),
        const SizedBox(width: AppSpacing.s12),
        Expanded(child: confirm),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.variant});

  final ConfirmDialogVariant variant;

  @override
  Widget build(BuildContext context) {
    final (background, foreground, icon) = switch (variant) {
      ConfirmDialogVariant.danger => (
        AppColors.dangerTint,
        AppColors.danger,
        Icons.delete_outline,
      ),
      ConfirmDialogVariant.primary => (
        AppColors.primaryTint,
        AppColors.primary,
        Icons.check_rounded,
      ),
      ConfirmDialogVariant.info => (
        AppColors.tintOrange,
        AppColors.accentOrange,
        Icons.priority_high,
      ),
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadius.fullAll,
      ),
      child: SizedBox(
        width: ConfirmDialog.iconBadgeExtent,
        height: ConfirmDialog.iconBadgeExtent,
        child: Icon(icon, color: foreground, size: AppSpacing.s24),
      ),
    );
  }
}
