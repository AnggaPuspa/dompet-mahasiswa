import 'dart:io';

import 'package:dompet_mahasiswa/database/database_helper.dart';
import 'package:dompet_mahasiswa/main.dart';
import 'package:dompet_mahasiswa/theme/app_text_styles.dart';
import 'package:dompet_mahasiswa/theme/app_theme.dart';
import 'package:dompet_mahasiswa/utils/app_strings.dart';
// Paket pengganti material_ui belum ada di SDK ini. development punya info yang sama.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'support/sqlite_setup.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('aset Lexend Deca ikut di-bundle', () async {
    const paths = <String>[
      'assets/fonts/LexendDeca-Regular.ttf',
      'assets/fonts/LexendDeca-Medium.ttf',
      'assets/fonts/LexendDeca-SemiBold.ttf',
      'assets/fonts/LexendDeca-Bold.ttf',
    ];

    for (final path in paths) {
      final data = await rootBundle.load(path);
      expect(data.lengthInBytes, greaterThan(0), reason: path);
    }
  });

  test('AppTheme memakai family yang sama dengan AppTextStyles', () {
    final theme = AppTheme.light();
    final textTheme = theme.textTheme;

    final styles = <TextStyle?>[
      textTheme.displayLarge,
      textTheme.displayMedium,
      textTheme.displaySmall,
      textTheme.headlineLarge,
      textTheme.headlineMedium,
      textTheme.headlineSmall,
      textTheme.titleLarge,
      textTheme.titleMedium,
      textTheme.titleSmall,
      textTheme.bodyLarge,
      textTheme.bodyMedium,
      textTheme.bodySmall,
      textTheme.labelLarge,
      textTheme.labelMedium,
      textTheme.labelSmall,
      theme.primaryTextTheme.bodyMedium,
      theme.appBarTheme.titleTextStyle,
      theme.inputDecorationTheme.labelStyle,
      theme.inputDecorationTheme.hintStyle,
      theme.snackBarTheme.contentTextStyle,
    ];

    for (final style in styles) {
      expect(style?.fontFamily, AppTextStyles.fontFamily);
    }
  });

  testWidgets('teks aplikasi memakai Lexend Deca', (tester) async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfiNoIsolate;
    silenceDatabaseLockWarning();
    final directory = Directory.systemTemp.createTempSync('font_test_');
    DatabaseHelper.pathResolver = () async {
      return path.join(directory.path, 'test.db');
    };
    addTearDown(() async {
      await DatabaseHelper.reset();
      DatabaseHelper.pathResolver = DatabaseHelper.lokasiBawaan;
      if (directory.existsSync()) {
        directory.deleteSync(recursive: true);
      }
    });

    await tester.runAsync(() => tester.pumpWidget(const DompetMahasiswaApp()));

    for (var attempt = 0; attempt < 100; attempt++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 10)),
      );
      await tester.pump(const Duration(milliseconds: 30));
      if (find.text(AppStrings.belumAdaData).evaluate().isNotEmpty) {
        await tester.pump(const Duration(milliseconds: 300));
        break;
      }
    }
    expect(find.text(AppStrings.belumAdaData), findsOneWidget);

    // MainShell sendiri masih di atas Material. Teks di dalam Scaffold
    // mewarisi DefaultTextStyle dari theme.
    final context = tester.element(find.text(AppStrings.belumAdaData));
    expect(
      DefaultTextStyle.of(context).style.fontFamily,
      AppTextStyles.fontFamily,
    );
  });
}
