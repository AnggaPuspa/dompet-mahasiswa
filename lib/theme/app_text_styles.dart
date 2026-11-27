import 'package:dompet_mahasiswa/theme/app_colors.dart';
import 'package:flutter/material.dart';

// Huruf yang benar-benar ada di Figma. Jangan menambah style lain,
// karena layar nanti memakai nama yang tidak ada di desain.
class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = 'Lexend Deca';

  static const TextStyle display = TextStyle(
    fontFamily: fontFamily,
    fontSize: 33,
    fontWeight: FontWeight.w700,
    height: 1.0,
    color: AppColors.text,
  );

  static const TextStyle heading24 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.0,
    color: AppColors.text,
  );

  static const TextStyle heading19 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 19,
    fontWeight: FontWeight.w600,
    height: 1.0,
    color: AppColors.text,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.0,
    color: AppColors.text,
  );

  static const TextStyle bodyStrong = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.0,
    color: AppColors.text,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 1.0,
    color: AppColors.textMuted,
  );

  static const TextStyle captionStrong = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 1.0,
    color: AppColors.text,
  );

  static const TextStyle label = TextStyle(
    fontFamily: fontFamily,
    fontSize: 9,
    fontWeight: FontWeight.w400,
    height: 1.0,
    color: AppColors.textMuted,
  );

  static const TextStyle h1 = heading24;
  static const TextStyle h2 = heading19;

  /// Mengempiskan teks error bawaan Material supaya pesannya
  /// bisa digambar di luar kartu field.
  static const TextStyle hidden = TextStyle(
    fontSize: 0,
    height: 0,
    color: AppColors.transparent,
  );
}
