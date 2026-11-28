import 'package:dompet_mahasiswa/theme/app_colors.dart';
import 'package:dompet_mahasiswa/theme/app_spacing.dart';
import 'package:dompet_mahasiswa/theme/app_text_styles.dart';
import 'package:dompet_mahasiswa/widgets/app_back_button.dart';
import 'package:dompet_mahasiswa/widgets/app_notification_button.dart';
import 'package:flutter/material.dart';

/// Header setinggi 24: kembali atau spacer, judul tengah, lonceng.
///
/// [showBack] false adalah header tab (spacer kiri). True adalah header kembali.
class AppPageHeader extends StatelessWidget {
  const AppPageHeader({
    super.key,
    required this.title,
    this.showBack = false,
    this.backEnabled = true,
    this.onBack,
    this.notificationColor = AppColors.text,
    this.badgeColor = AppColors.primary,
  });

  final String title;
  final bool showBack;
  final bool backEnabled;
  final VoidCallback? onBack;
  final Color notificationColor;
  final Color badgeColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.s24,
      child: Row(
        children: [
          if (showBack)
            AppBackButton(onPressed: onBack, enabled: backEnabled)
          else
            const SizedBox(width: AppSpacing.s24, height: AppSpacing.s24),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.heading19,
            ),
          ),
          AppNotificationButton(
            color: notificationColor,
            badgeColor: badgeColor,
          ),
        ],
      ),
    );
  }
}
