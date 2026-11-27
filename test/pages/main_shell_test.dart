import 'dart:io';

import 'package:dompet_mahasiswa/database/database_helper.dart';
import 'package:dompet_mahasiswa/main.dart';
import 'package:dompet_mahasiswa/theme/app_colors.dart';
import 'package:dompet_mahasiswa/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../support/sqlite_setup.dart';

void main() {
  testWidgets('shell berpindah ke lima tujuan dan membuka form dompet', (
    tester,
  ) async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfiNoIsolate;
    silenceDatabaseLockWarning();
    final directory = Directory.systemTemp.createTempSync('shell_');
    DatabaseHelper.pathResolver = () async {
      return path.join(directory.path, 'test.db');
    };
    await DatabaseHelper.reset();
    addTearDown(() async {
      await DatabaseHelper.reset();
      DatabaseHelper.pathResolver = DatabaseHelper.lokasiBawaan;
      if (directory.existsSync()) {
        directory.deleteSync(recursive: true);
      }
    });
    final dispatcher = tester.binding.platformDispatcher;
    dispatcher.accessibilityFeaturesTestValue = const FakeAccessibilityFeatures(
      disableAnimations: true,
    );
    addTearDown(dispatcher.clearAccessibilityFeaturesTestValue);
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(375, 812);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.runAsync(() => tester.pumpWidget(const DompetMahasiswaApp()));
    await _waitFor(tester, find.text(AppStrings.belumAdaData));

    expect(_iconColor(tester, AppStrings.dashboard), AppColors.primary);
    expect(_iconColor(tester, AppStrings.dompet), AppColors.primarySoft);

    await tester.tap(find.byTooltip(AppStrings.dompet));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.widgetWithText(AppBar, AppStrings.dompet), findsOneWidget);
    expect(_iconColor(tester, AppStrings.dompet), AppColors.primary);
    expect(_iconColor(tester, AppStrings.dashboard), AppColors.primarySoft);

    await tester.tap(find.text(AppStrings.tambahDompet));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text(AppStrings.namaDompet), findsOneWidget);
    expect(find.text(AppStrings.hintNamaDompet), findsOneWidget);

    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text(AppStrings.namaDompet), findsNothing);

    await tester.tap(find.byTooltip(AppStrings.transaksi));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.widgetWithText(AppBar, AppStrings.transaksi), findsOneWidget);
    expect(find.text(AppStrings.halamanBelumSiap), findsOneWidget);

    await tester.tap(find.byTooltip(AppStrings.riwayat));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.widgetWithText(AppBar, AppStrings.riwayat), findsOneWidget);
    expect(_iconColor(tester, AppStrings.riwayat), AppColors.primary);

    await tester.tap(find.byTooltip(AppStrings.kategori));
    await tester.pump();
    await _waitFor(tester, find.text(AppStrings.belumAdaKategori));
    expect(find.widgetWithText(AppBar, AppStrings.kategori), findsOneWidget);
    expect(_iconColor(tester, AppStrings.kategori), AppColors.primary);

    await tester.tap(find.byTooltip(AppStrings.dashboard));
    await tester.pump();
    await _waitFor(tester, find.text(AppStrings.belumAdaData));
    expect(_iconColor(tester, AppStrings.dashboard), AppColors.primary);
    // Muat ulang tab dashboard selesai sebelum tes ditutup.
    await _drain(tester);
  });
}

Color _iconColor(WidgetTester tester, String tooltip) {
  final icon = tester.widget<Icon>(
    find.descendant(of: find.byTooltip(tooltip), matching: find.byType(Icon)),
  );
  return icon.color!;
}

Future<void> _drain(WidgetTester tester) async {
  for (var attempt = 0; attempt < 15; attempt++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pump(const Duration(milliseconds: 30));
  }
}

Future<void> _waitFor(WidgetTester tester, Finder finder) async {
  for (var attempt = 0; attempt < 100; attempt++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 10)),
    );
    await tester.pump(const Duration(milliseconds: 30));
    if (finder.evaluate().isNotEmpty) {
      await tester.pump(const Duration(milliseconds: 300));
      return;
    }
  }
  expect(finder, findsOneWidget);
}
