import 'dart:io';

import 'package:dompet_mahasiswa/theme/app_text_styles.dart';
import 'package:flutter/services.dart';

var _loaded = false;

/// Mendaftarkan Lexend Deca dan Material Icons.
///
/// `flutter test` memakai font uji (kotak) dan tidak memasang font aset.
/// Tangkapan layar butuh font asli supaya teks dan ikon kebaca.
Future<void> loadProofFonts() async {
  if (_loaded) {
    return;
  }
  final text = FontLoader(AppTextStyles.fontFamily);
  for (final asset in const [
    'assets/fonts/LexendDeca-Regular.ttf',
    'assets/fonts/LexendDeca-Medium.ttf',
    'assets/fonts/LexendDeca-SemiBold.ttf',
    'assets/fonts/LexendDeca-Bold.ttf',
  ]) {
    text.addFont(rootBundle.load(asset));
  }
  await text.load();

  const iconsPath =
      '/tmp/flutter-sdk/flutter/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf';
  final icons = File(iconsPath);
  if (icons.existsSync()) {
    final iconFont = FontLoader('MaterialIcons');
    iconFont.addFont(
      Future<ByteData>.value(ByteData.sublistView(icons.readAsBytesSync())),
    );
    await iconFont.load();
  }
  _loaded = true;
}
