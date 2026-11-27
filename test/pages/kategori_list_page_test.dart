import 'dart:io';

import 'package:dompet_mahasiswa/database/database_helper.dart';
import 'package:dompet_mahasiswa/domain/entities/kategori.dart';
import 'package:dompet_mahasiswa/pages/main_shell.dart';
import 'package:dompet_mahasiswa/utils/app_strings.dart';
import 'package:dompet_mahasiswa/widgets/app_button.dart';
import 'package:dompet_mahasiswa/widgets/category_card.dart';
import 'package:dompet_mahasiswa/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../support/capture.dart';
import '../support/proof_fonts.dart';
import '../support/sqlite_setup.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfiNoIsolate;
    silenceDatabaseLockWarning();
  });

  late Directory directory;

  setUp(() async {
    directory = Directory.systemTemp.createTempSync('kategori_list_');
    DatabaseHelper.pathResolver = () async {
      return path.join(directory.path, 'test.db');
    };
    await DatabaseHelper.reset();
  });

  tearDown(() async {
    await DatabaseHelper.reset();
    DatabaseHelper.pathResolver = DatabaseHelper.lokasiBawaan;
    if (directory.existsSync()) {
      directory.deleteSync(recursive: true);
    }
  });

  Future<void> waitFor(WidgetTester tester, Finder finder) async {
    for (var attempt = 0; attempt < 40; attempt++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await tester.pump(const Duration(milliseconds: 30));
      if (finder.evaluate().isNotEmpty) {
        return;
      }
    }
    expect(finder, findsOneWidget);
  }

  Future<void> settleAssets(WidgetTester tester) async {
    for (var attempt = 0; attempt < 8; attempt++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 40)),
      );
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  Future<void> pumpShell(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(375, 812);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.runAsync(loadProofFonts);
    await tester.runAsync(
      () => tester.pumpWidget(
        const MaterialApp(
          home: RepaintBoundary(key: Key('proof-list'), child: MainShell()),
        ),
      ),
    );
    await waitFor(tester, find.byTooltip(AppStrings.kategori));
    await tester.tap(find.byTooltip(AppStrings.kategori));
    await tester.pump();
  }

  testWidgets('daftar kosong menampilkan pesan dan tombol tambah', (
    tester,
  ) async {
    await pumpShell(tester);
    await waitFor(tester, find.text(AppStrings.belumAdaKategori));

    expect(find.text(AppStrings.kategori), findsOneWidget);
    expect(find.text(AppStrings.belumAdaKategori), findsOneWidget);
    expect(find.text(AppStrings.pesanKategoriKosong), findsOneWidget);
    expect(find.byType(EmptyState), findsWidgets);
    expect(find.text(AppStrings.tambahKategori), findsOneWidget);
    expect(find.byType(CategoryCard), findsNothing);

    await settleAssets(tester);
    await captureFinder(
      tester,
      find.byKey(const Key('proof-list')),
      'kategori-empty',
    );
  });

  testWidgets('daftar terisi memakai kartu global dan tombol aksi', (
    tester,
  ) async {
    const rows = [
      ('Uang Saku', AppStrings.pemasukan),
      ('Gaji Part-time', AppStrings.pemasukan),
      ('Makan & Minum', AppStrings.pengeluaran),
      ('Transportasi', AppStrings.pengeluaran),
      ('Kuota & Pulsa', AppStrings.pengeluaran),
    ];
    await tester.runAsync(() async {
      for (final row in rows) {
        await DatabaseHelper.instance.insertKategori(
          Kategori(nama: row.$1, jenis: row.$2),
        );
      }
      // Koneksi dibuka di sini. Tutup dulu supaya halaman membukanya
      // lagi di runAsync berikutnya tanpa kunci yang nyangkut.
      await DatabaseHelper.reset();
    });

    await pumpShell(tester);
    await waitFor(tester, find.text('Uang Saku'));

    expect(find.byType(CategoryCard), findsNWidgets(rows.length));
    expect(find.text(AppStrings.semuaKategori), findsOneWidget);
    expect(find.text('${rows.length}'), findsOneWidget);
    expect(find.text(AppStrings.tambahKategoriAksi), findsOneWidget);
    expect(find.text('Uang Saku'), findsOneWidget);
    expect(find.text('Kuota & Pulsa'), findsOneWidget);

    final button = tester.widget<AppButton>(
      find.widgetWithText(AppButton, AppStrings.tambahKategoriAksi),
    );
    expect(button.variant, AppButtonVariant.secondary);

    await settleAssets(tester);
    await captureFinder(
      tester,
      find.byKey(const Key('proof-list')),
      'kategori-list',
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: RepaintBoundary(
              key: Key('proof-card'),
              child: SizedBox(
                width: 331,
                child: CategoryCard(
                  name: 'Uang Saku',
                  jenis: AppStrings.pemasukan,
                  style: CategoryCardStyle.uangSaku,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await captureFinder(
      tester,
      find.byKey(const Key('proof-card')),
      'kategori-card',
    );
  });
}
