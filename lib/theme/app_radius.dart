import 'package:flutter/material.dart';

// Sudut lengkung. Nilainya dari token Figma radius/*.
class AppRadius {
  AppRadius._();

  static const double sm = 7;
  static const double tile = 9;
  static const double pill = 10;
  static const double button = 14;
  static const double md = 15;
  static const double lg = 19;
  static const double xl = 24;
  static const double full = 100;

  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius tileAll = BorderRadius.all(Radius.circular(tile));
  static const BorderRadius pillAll = BorderRadius.all(Radius.circular(pill));
  static const BorderRadius buttonAll = BorderRadius.all(
    Radius.circular(button),
  );
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgAll = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius xlAll = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius fullAll = BorderRadius.all(Radius.circular(full));
}
