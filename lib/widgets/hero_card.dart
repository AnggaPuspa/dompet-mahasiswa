import 'dart:math' as math;

import 'package:dompet_mahasiswa/theme/app_colors.dart';
import 'package:dompet_mahasiswa/theme/app_radius.dart';
import 'package:dompet_mahasiswa/theme/app_shadows.dart';
import 'package:dompet_mahasiswa/theme/app_spacing.dart';
import 'package:dompet_mahasiswa/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Kartu hero 331×146, sudut [AppRadius.xl], bayangan [AppShadows.hero].
///
/// Frame Figma HeroCard memakai keterangan, dua baris isi, tombol pil,
/// dan cincin persen. Nominal besar `display` tidak ada di frame ini,
/// jadi teks isi memakai [AppTextStyles.body] di atas warna primary.
/// Semua kalimat diisi pemanggil.
class HeroCard extends StatelessWidget {
  const HeroCard({
    super.key,
    required this.caption,
    required this.line1,
    required this.line2,
    required this.buttonLabel,
    required this.percent,
    this.onButtonPressed,
  });

  final String caption;
  final String line1;
  final String line2;
  final String buttonLabel;

  /// Angka 0 sampai 100 yang digambar di cincin.
  final int percent;
  final VoidCallback? onButtonPressed;

  static const double frameWidth = 331;
  static const double frameHeight = 146;

  /// Diameter cincin di frame HeroCard. Belum ada token space untuk 76.
  static const double ringExtent = 76;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: frameWidth,
      height: frameHeight,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.primary,
          borderRadius: AppRadius.xlAll,
          boxShadow: AppShadows.hero,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.s22),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        caption,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primaryTint,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s4),
                      Text(
                        line1,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.onPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s4),
                      Text(
                        line2,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.onPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s6),
                      _HeroPill(label: buttonLabel, onPressed: onButtonPressed),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.s12),
                _ProgressRing(percent: _percent),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int get _percent {
    if (percent < 0) {
      return 0;
    }
    if (percent > 100) {
      return 100;
    }
    return percent;
  }
}

class _HeroPill extends StatelessWidget {
  const _HeroPill({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.pillAll),
      child: InkWell(
        onTap: onPressed,
        customBorder: const RoundedRectangleBorder(
          borderRadius: AppRadius.pillAll,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s20,
            vertical: AppSpacing.s8,
          ),
          child: Text(
            label,
            style: AppTextStyles.bodyStrong.copyWith(color: AppColors.primary),
          ),
        ),
      ),
    );
  }
}

class _ProgressRing extends StatelessWidget {
  const _ProgressRing({required this.percent});

  final int percent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: HeroCard.ringExtent,
      height: HeroCard.ringExtent,
      child: CustomPaint(
        painter: _RingPainter(percent: percent),
        child: Center(
          child: Text(
            '$percent%',
            style: AppTextStyles.body.copyWith(color: AppColors.onPrimary),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({required this.percent});

  final int percent;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = AppSpacing.s8;
    final rect = Offset.zero & size;
    final arc = rect.deflate(stroke / 2);
    final track = Paint()
      ..color = AppColors.primaryTint
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(arc, 0, math.pi * 2, false, track);
    if (percent == 0) {
      return;
    }
    final progress = Paint()
      ..color = AppColors.onPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      arc,
      -math.pi / 2,
      math.pi * 2 * percent / 100,
      false,
      progress,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.percent != percent;
  }
}
