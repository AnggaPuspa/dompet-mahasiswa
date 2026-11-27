import 'package:dompet_mahasiswa/theme/app_spacing.dart';
import 'package:dompet_mahasiswa/theme/app_text_styles.dart';
import 'package:dompet_mahasiswa/widgets/app_button.dart';
import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    this.message,
    this.icon,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? message;
  final Widget? icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final illustration = icon;
    final description = message;
    final label = actionLabel;
    final action = onAction;

    return Center(
      child: SingleChildScrollView(
        padding: AppSpacing.pad20,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (illustration != null) ...[
              illustration,
              const SizedBox(height: AppSpacing.s16),
            ],
            Text(title, style: AppTextStyles.h2, textAlign: TextAlign.center),
            if (description != null) ...[
              const SizedBox(height: AppSpacing.s8),
              Text(
                description,
                style: AppTextStyles.body,
                textAlign: TextAlign.center,
              ),
            ],
            if (label != null && action != null) ...[
              const SizedBox(height: AppSpacing.s24),
              AppButton(label: label, onPressed: action),
            ],
          ],
        ),
      ),
    );
  }
}
