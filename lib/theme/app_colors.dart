import 'package:flutter/material.dart';

// Semua warna aplikasi ada di sini, diambil dari Figma "Dompet Tokens" (mode Light).
// Jangan tulis Color(0xFF...) di file lain. Kalau warna Figma berubah,
// yang diganti cuma file ini.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF5F33E1);
  static const Color primaryLight = Color(0xFF8764FF);
  static const Color primaryTint = Color(0xFFEEE9FF);
  static const Color primarySoft = Color(0xFFAB94FF);
  static const Color onPrimary = Color(0xFFFFFFFF);

  static const Color text = Color(0xFF24252C);
  static const Color textMuted = Color(0xFF6E6A7C);
  static const Color textBlack = Color(0xFF000000);

  static const Color transparent = Colors.transparent;
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color outline = Color(0xFFEFF0F7);

  static const Color tintBlue = Color(0xFFE7F3FF);
  static const Color tintOrange = Color(0xFFFFE9E1);
  static const Color tintPink = Color(0xFFFFE4F2);
  static const Color tintLilac = Color(0xFFEDE8FF);
  static const Color tintViolet = Color(0xFFEDE4FF);
  static const Color tintSky = Color(0xFFE3F2FF);
  static const Color tintPeach = Color(0xFFFFE6D4);
  static const Color tintYellow = Color(0xFFFFF6D4);

  static const Color accentBlue = Color(0xFF0087FF);
  static const Color accentOrange = Color(0xFFFF7D53);
  static const Color accentPink = Color(0xFFF478B8);
  static const Color accentPurple = Color(0xFF9260F4);
  static const Color accentAmber = Color(0xFFFF9142);
  static const Color accentYellow = Color(0xFFFFD12E);

  static const Color success = Color(0xFF3DD68C);
  static const Color successStrong = Color(0xFF22B573);
  static const Color successTint = Color(0xFFE0F6EA);
  static const Color danger = Color(0xFFF0566E);
  static const Color dangerTint = Color(0xFFFFE5EA);

  // Bayangan Figma. Hex-nya tetap di file ini, bukan di widget.
  static const Color shadowCard = Color(0x0A000000);
  static const Color shadowHero = Color(0x08000000);
  static const Color shadowPrimary = Color(0x7D5F33E1);

  // Bukan warna baru. Layar cukup menulis pemasukan/pengeluaran,
  // tanpa perlu tahu nama success/danger dari Figma.
  static const Color pemasukan = success;
  static const Color pengeluaran = danger;
}
