import 'package:dompet_mahasiswa/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

export 'package:flutter/material.dart';

Future<void> pumpApp(WidgetTester tester, Widget child) {
  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(
        body: Align(alignment: Alignment.topLeft, child: child),
      ),
    ),
  );
}

BoxDecoration decorationOf(WidgetTester tester, Finder finder) {
  final box = tester.widget<DecoratedBox>(finder);
  return box.decoration as BoxDecoration;
}
