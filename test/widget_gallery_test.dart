import 'dart:io';
import 'dart:ui' as ui;

import 'package:dompet_mahasiswa/theme/app_colors.dart';
import 'package:dompet_mahasiswa/theme/app_text_styles.dart';
import 'package:dompet_mahasiswa/utils/app_strings.dart';
import 'package:dompet_mahasiswa/utils/currency_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/widget_gallery.dart';

const _galleryBoundary = Key('widget-gallery-boundary');

/// Tema lokal supaya galeri tidak memicu unduhan Google Fonts di tes.
ThemeData _galleryTheme() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: AppTextStyles.fontFamily,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      surface: AppColors.surface,
      onSurface: AppColors.text,
      error: AppColors.danger,
      onError: AppColors.onPrimary,
    ),
    scaffoldBackgroundColor: AppColors.background,
  );
}

Future<void> _loadFont(String family, String path) async {
  final file = File(path);
  if (!file.existsSync()) {
    return;
  }
  final bytes = file.readAsBytesSync();
  final loader = FontLoader(family);
  loader.addFont(
    Future<ByteData>.value(ByteData.sublistView(Uint8List.fromList(bytes))),
  );
  await loader.load();
}

Future<void> _loadGalleryFonts() async {
  await _loadFont(
    AppTextStyles.fontFamily,
    '/tmp/fonts/LexendDeca-Regular.ttf',
  );
  final home = Platform.environment['HOME'];
  if (home == null) {
    return;
  }
  await _loadFont(
    'MaterialIcons',
    '$home/flutter-sdk/flutter/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
  );
}

void main() {
  testWidgets('galeri widget global tampil utuh', (tester) async {
    tester.view.physicalSize = const Size(760, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.runAsync(_loadGalleryFonts);

    await tester.pumpWidget(
      MaterialApp(
        theme: _galleryTheme(),
        home: const Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: RepaintBoundary(
              key: _galleryBoundary,
              child: WidgetGallery(),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text(AppStrings.lihatRiwayat), findsOneWidget);
    expect(find.text(AppStrings.totalSaldo), findsOneWidget);
    expect(find.text('+${formatRupiah(10000)}'), findsOneWidget);
    expect(find.text('-${formatRupiah(20000)}'), findsOneWidget);
    expect(find.text(AppStrings.semua), findsOneWidget);
    expect(find.text(AppStrings.periodeBulanan), findsOneWidget);
    expect(find.text(AppStrings.jenis), findsOneWidget);

    final directory = Directory('/opt/cursor/artifacts');
    if (!directory.existsSync()) {
      return;
    }
    final boundary = tester.renderObject<RenderRepaintBoundary>(
      find.byKey(_galleryBoundary),
    );
    final bytes = await tester.runAsync(() async {
      final image = await boundary.toImage(pixelRatio: 2);
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();
      return data!.buffer.asUint8List();
    });
    File('${directory.path}/widget_gallery.png').writeAsBytesSync(bytes!);
  });
}
