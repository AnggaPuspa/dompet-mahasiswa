import 'package:dompet_mahasiswa/theme/app_colors.dart';
import 'package:dompet_mahasiswa/theme/app_radius.dart';
import 'package:dompet_mahasiswa/theme/app_spacing.dart';
import 'package:dompet_mahasiswa/theme/app_text_styles.dart';
import 'package:dompet_mahasiswa/widgets/icon_tile.dart';
import 'package:flutter/material.dart';

/// Kartu ringkasan 331×106, sudut [AppRadius.lg].
///
/// Nominal memakai [AppTextStyles.bodyStrong] sesuai kontrak #3.
/// Label dan info memakai caption. Ikon kanan atas bisa diganti;
/// bawaan mengikuti tile dompet di Figma.
class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.label,
    required this.amount,
    required this.info,
    this.icon,
    this.onTap,
  });

  final String label;
  final String amount;
  final String info;
  final Widget? icon;
  final VoidCallback? onTap;

  static const double frameWidth = 331;
  static const double frameHeight = 106;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: frameWidth,
      height: frameHeight,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.tintBlue,
          borderRadius: AppRadius.lgAll,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppRadius.lgAll,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.s16),
                  child: Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.s32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption,
                        ),
                        const SizedBox(height: AppSpacing.s12),
                        Text(
                          amount,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodyStrong.copyWith(
                            color: AppColors.textBlack,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.s12),
                        Text(
                          info,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: AppSpacing.s12,
                  right: AppSpacing.s12,
                  child: IconTile(
                    icon: icon ?? const Icon(Icons.account_balance_wallet),
                    background: AppColors.tintPink,
                    foreground: AppColors.accentPink,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
