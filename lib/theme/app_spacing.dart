import 'package:flutter/material.dart';

// Jarak layar. Angkanya sama dengan token Figma space/*.
// Widget cukup menulis AppSpacing.s16, bukan angka 16 yang tersebar.
class AppSpacing {
  AppSpacing._();

  static const double s2 = 2;
  static const double s4 = 4;
  static const double s6 = 6;
  static const double s8 = 8;
  static const double s10 = 10;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s20 = 20;
  static const double s22 = 22;
  static const double s24 = 24;
  static const double s28 = 28;
  static const double s32 = 32;

  static const EdgeInsets pad12 = EdgeInsets.all(s12);
  static const EdgeInsets pad16 = EdgeInsets.all(s16);
  static const EdgeInsets pad20 = EdgeInsets.all(s20);
  static const EdgeInsets horizontal16 = EdgeInsets.symmetric(horizontal: s16);
  static const EdgeInsets horizontal20 = EdgeInsets.symmetric(horizontal: s20);
}
