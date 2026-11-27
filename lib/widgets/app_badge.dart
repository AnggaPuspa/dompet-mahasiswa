import 'package:dompet_mahasiswa/theme/app_radius.dart';
import 'package:dompet_mahasiswa/theme/app_spacing.dart';
import 'package:dompet_mahasiswa/theme/app_text_styles.dart';
import 'package:dompet_mahasiswa/utils/color_helper.dart';
import 'package:flutter/material.dart';

/// Badge tinggi 14, sudut [AppRadius.sm] (setengah tinggi, jadi bentuk pil).
///
/// Varian pemasukan/pengeluaran memakai [colorForJenis] dan [backgroundForJenis].
/// Untuk badge hitungan (bukan jenis), isi [foreground] dan [background] sendiri.
/// Itu pola yang sama dengan `_Badge` di daftar kategori.
class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.label,
    this.jenis,
    this.foreground,
    this.background,
  }) : assert(
         jenis != null || (foreground != null && background != null),
         'Badge butuh jenis, atau warna teks beserta latar',
       );

  final String label;

  /// `'Pemasukan'` atau `'Pengeluaran'`. Menentukan warna bila [foreground]
  /// dan [background] tidak diisi.
  final String? jenis;
  final Color? foreground;
  final Color? background;

  /// Tinggi frame Figma Badge. Belum ada token space untuk 14.
  static const double frameHeight = 14;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _background,
        borderRadius: AppRadius.smAll,
      ),
      child: SizedBox(
        height: frameHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s6),
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.label.copyWith(color: _foreground),
            ),
          ),
        ),
      ),
    );
  }

  Color get _foreground => foreground ?? colorForJenis(jenis!);

  Color get _background => background ?? backgroundForJenis(jenis!);
}
