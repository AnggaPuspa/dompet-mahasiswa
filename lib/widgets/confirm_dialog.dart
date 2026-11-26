import 'package:dompet_mahasiswa/theme/app_colors.dart';
import 'package:dompet_mahasiswa/theme/app_radius.dart';
import 'package:dompet_mahasiswa/theme/app_spacing.dart';
import 'package:dompet_mahasiswa/theme/app_text_styles.dart';
import 'package:dompet_mahasiswa/utils/app_strings.dart';
import 'package:dompet_mahasiswa/widgets/app_button.dart';
import 'package:flutter/material.dart';

abstract final class ConfirmDialog {
  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = AppStrings.hapus,
    String? cancelLabel = AppStrings.batal,
    bool isDanger = true,
    Widget? icon,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierColor: AppColors.dialogScrim,
      builder: (context) => Dialog(
        backgroundColor: AppColors.surface,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.xlAll),
        insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.s32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 311),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.s24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  icon,
                  const SizedBox(height: AppSpacing.s16),
                ],
                Text(
                  title,
                  style: AppTextStyles.h2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.s16),
                Text(
                  message,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textMuted,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.s16),
                Row(
                  children: [
                    if (cancelLabel != null) ...[
                      Expanded(
                        child: AppButton(
                          label: cancelLabel,
                          variant: AppButtonVariant.tinted,
                          onPressed: () => Navigator.pop(context, false),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s12),
                    ],
                    Expanded(
                      child: AppButton(
                        label: confirmLabel,
                        variant: isDanger
                            ? AppButtonVariant.danger
                            : AppButtonVariant.primary,
                        onPressed: () => Navigator.pop(context, true),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    return result ?? false;
  }
}
