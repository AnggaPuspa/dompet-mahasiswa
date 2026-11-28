import 'package:dompet_mahasiswa/theme/app_colors.dart';
import 'package:flutter/material.dart';

// Bayangan kartu Figma. Widget memakai AppShadows.card, bukan BoxShadow sendiri.
class AppShadows {
  AppShadows._();

  static const List<BoxShadow> card = [
    BoxShadow(
      color: AppColors.shadowCard,
      offset: Offset(0, 4),
      blurRadius: 32,
    ),
  ];

  static const List<BoxShadow> hero = [
    BoxShadow(color: AppColors.shadowHero, offset: Offset.zero, blurRadius: 20),
  ];

  static const List<BoxShadow> primary = [
    BoxShadow(
      color: AppColors.shadowPrimary,
      offset: Offset(0, 10),
      blurRadius: 18,
    ),
  ];

  /// Elips glow di bawah tombol primer (node AppButton/Primary).
  ///
  /// Tinggi 7, menempel 2 px di bawah tepi tombol. Layer blur Figma 30
  /// dipetakan ke sigma 15. [glowBleed] menampung hasil blur supaya tidak
  /// terpotong. Bukan [primary].
  static const double glowHeight = 7;
  static const double glowInsetEnd = 9;
  static const double glowDrop = 2;
  static const double glowBlurSigma = 11;
  static const double glowBleed = 26;
}
