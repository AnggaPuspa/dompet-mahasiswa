import 'package:dompet_mahasiswa/theme/app_colors.dart';
import 'package:dompet_mahasiswa/theme/app_radius.dart';
import 'package:dompet_mahasiswa/theme/app_spacing.dart';
import 'package:dompet_mahasiswa/theme/app_text_styles.dart';
import 'package:dompet_mahasiswa/widgets/icon_tile.dart';
import 'package:flutter/material.dart';

/// Varian warna WalletCard. Biru, oranye, dan merah muda.
enum WalletCardVariant { blue, orange, pink }

/// Kartu dompet 202×116, sudut [AppRadius.lg].
///
/// [progress] adalah 0 sampai 1 dan mengisi batang aksen.
/// Nama, label, dan nominal diisi pemanggil (nominal lewat format rupiah).
class WalletCard extends StatelessWidget {
  const WalletCard({
    super.key,
    required this.variant,
    required this.label,
    required this.name,
    required this.amount,
    this.progress = 0,
    this.icon,
    this.onTap,
  });

  final WalletCardVariant variant;
  final String label;
  final String name;
  final String amount;
  final double progress;
  final Widget? icon;
  final VoidCallback? onTap;

  static const double frameWidth = 202;
  static const double frameHeight = 116;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: frameWidth,
      height: frameHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _background,
          borderRadius: AppRadius.lgAll,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppRadius.lgAll,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption,
                        ),
                      ),
                      IconTile(
                        icon: icon ?? const Icon(Icons.account_balance_wallet),
                        background: AppColors.tintPink,
                        foreground: AppColors.accentPink,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s12),
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textBlack,
                    ),
                  ),
                  Text(
                    amount,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textBlack,
                    ),
                  ),
                  const Spacer(),
                  _ProgressBar(progress: _progress, color: _accent),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  double get _progress {
    if (progress.isNaN || progress < 0) {
      return 0;
    }
    if (progress > 1) {
      return 1;
    }
    return progress;
  }

  Color get _background {
    return switch (variant) {
      WalletCardVariant.blue => AppColors.tintBlue,
      WalletCardVariant.orange => AppColors.tintOrange,
      WalletCardVariant.pink => AppColors.tintPink,
    };
  }

  Color get _accent {
    return switch (variant) {
      WalletCardVariant.blue => AppColors.accentBlue,
      WalletCardVariant.orange => AppColors.accentOrange,
      WalletCardVariant.pink => AppColors.accentPink,
    };
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadius.fullAll,
      child: SizedBox(
        height: AppSpacing.s6,
        width: double.infinity,
        child: ColoredBox(
          color: AppColors.surface,
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: progress,
              heightFactor: 1,
              child: ColoredBox(color: color),
            ),
          ),
        ),
      ),
    );
  }
}
