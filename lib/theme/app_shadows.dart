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
}
