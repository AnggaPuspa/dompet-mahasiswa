import 'package:dompet_mahasiswa/theme/app_colors.dart';
import 'package:dompet_mahasiswa/theme/app_spacing.dart';
import 'package:dompet_mahasiswa/theme/app_text_styles.dart';
import 'package:dompet_mahasiswa/utils/app_assets.dart';
import 'package:dompet_mahasiswa/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Daftar atau halaman kosong.
///
/// Ilustrasi bawaan adalah Lottie 220×176. [icon] menggantikannya
/// kalau pemanggil perlu gambar lain.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    this.message,
    this.icon,
    this.actionLabel,
    this.onAction,
    this.animation,
    this.padding = AppSpacing.pad20,
  });

  final String title;
  final String? message;
  final Widget? icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  /// Kalau diisi, pemanggil yang mengatur kemajuan ilustrasi.
  /// Kosong berarti animasi berjalan sendiri.
  final Animation<double>? animation;

  /// Jarak di sekeliling isi. Nol kalau induk sudah memberi padding halaman.
  final EdgeInsetsGeometry padding;

  /// Ukuran frame Figma Illustration/Empty. Bukan token jarak.
  static const double illustrationWidth = 220;
  static const double illustrationHeight = 176;

  /// Lebar teks EmptyState/Text di Figma.
  static const double textWidth = 300;

  @override
  Widget build(BuildContext context) {
    final description = message;
    final label = actionLabel;
    final action = onAction;

    return Center(
      child: SingleChildScrollView(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _visual(),
            const SizedBox(height: AppSpacing.s20),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: textWidth),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.h2,
                    textAlign: TextAlign.center,
                  ),
                  if (description != null) ...[
                    const SizedBox(height: AppSpacing.s8),
                    Text(
                      description,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textMuted,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
            if (label != null && action != null) ...[
              const SizedBox(height: AppSpacing.s20),
              AppButton(label: label, onPressed: action),
            ],
          ],
        ),
      ),
    );
  }

  Widget _visual() {
    final fallback = icon;
    if (fallback != null) {
      return fallback;
    }
    return Lottie.asset(
      AppAssets.emptyState,
      controller: animation,
      width: illustrationWidth,
      height: illustrationHeight,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return const SizedBox(
          width: illustrationWidth,
          height: illustrationHeight,
        );
      },
    );
  }
}
