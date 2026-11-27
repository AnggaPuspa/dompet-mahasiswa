import 'package:dompet_mahasiswa/main.dart';
import 'package:dompet_mahasiswa/theme/app_text_styles.dart';
import 'package:dompet_mahasiswa/theme/app_theme.dart';
import 'package:dompet_mahasiswa/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

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
    await tester.pumpWidget(const DompetMahasiswaApp());

    final context = tester.element(find.text(AppStrings.placeholderBody));
    expect(
      DefaultTextStyle.of(context).style.fontFamily,
      AppTextStyles.fontFamily,
    );
  });
}
