import 'dart:io';

import 'package:dompet_mahasiswa/database/database_helper.dart';
import 'package:dompet_mahasiswa/domain/entities/dompet.dart';
import 'package:dompet_mahasiswa/domain/entities/transaksi.dart';
import 'package:dompet_mahasiswa/domain/value_objects/jenis_kategori.dart';
import 'package:dompet_mahasiswa/main.dart';
import 'package:dompet_mahasiswa/pages/kategori_list_page.dart';
import 'package:dompet_mahasiswa/utils/app_strings.dart';
import 'package:dompet_mahasiswa/widgets/app_dropdown_form_field.dart';
// Paket pengganti material_ui belum ada di SDK ini. development punya info yang sama.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'support/sqlite_setup.dart';

void main() {
  testWidgets('aplikasi terbuka tanpa crash', (tester) async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfiNoIsolate;
    silenceDatabaseLockWarning();
    final directory = Directory.systemTemp.createTempSync('app_shell_');
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
    final dispatcher = tester.binding.platformDispatcher;
    dispatcher.accessibilityFeaturesTestValue = const FakeAccessibilityFeatures(
      disableAnimations: true,
    );
    addTearDown(dispatcher.clearAccessibilityFeaturesTestValue);

    await tester.runAsync(() => tester.pumpWidget(const DompetMahasiswaApp()));

    expect(find.byTooltip(AppStrings.dashboard), findsOneWidget);
    expect(find.byTooltip(AppStrings.riwayat), findsOneWidget);
    expect(find.byTooltip(AppStrings.transaksi), findsOneWidget);
    expect(find.byTooltip(AppStrings.dompet), findsOneWidget);
    expect(find.byTooltip(AppStrings.kategori), findsOneWidget);

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
  });

  testWidgets('kategori bisa dibuat, diubah, dan dihapus bila belum dipakai', (
    tester,
  ) async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfiNoIsolate;
    silenceDatabaseLockWarning();
    final directory = Directory.systemTemp.createTempSync('kategori_test_');
    var failFirstLoad = true;
    DatabaseHelper.pathResolver = () async {
      if (failFirstLoad) {
        failFirstLoad = false;
        throw StateError('Temporary database error');
      }
      return path.join(directory.path, 'test.db');
    };
    addTearDown(() async {
      await DatabaseHelper.reset();
      DatabaseHelper.pathResolver = DatabaseHelper.lokasiBawaan;
      directory.deleteSync(recursive: true);
    });

    final dispatcher = tester.binding.platformDispatcher;
    dispatcher.accessibilityFeaturesTestValue = const FakeAccessibilityFeatures(
      accessibleNavigation: true,
      disableAnimations: true,
    );
    addTearDown(dispatcher.clearAccessibilityFeaturesTestValue);
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(375, 812);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    Future<void> waitFor(Finder finder) async {
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

    await tester.runAsync(
      () => tester.pumpWidget(const MaterialApp(home: KategoriListPage())),
    );
    await waitFor(find.text(AppStrings.cobaLagi));
    await tester.runAsync(() async {
      await tester.tap(find.text(AppStrings.cobaLagi));
    });
    await waitFor(find.text(AppStrings.belumAdaKategori));

    await tester.tap(find.text(AppStrings.tambahKategori));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.simpan));
    await tester.pump();
    expect(find.text(AppStrings.namaKategoriWajib), findsOneWidget);
    expect(find.text(AppStrings.jenisWajib), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), 'Makan');
    await tester.tap(find.byType(AppDropdownFormField<JenisKategori>));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.pengeluaran).last);
    await tester.pumpAndSettle();
    await tester.runAsync(() async {
      await tester.tap(find.text(AppStrings.simpan));
    });
    await waitFor(find.text(AppStrings.kategoriDisimpan));
    await waitFor(find.text('Makan'));

    await tester.tap(find.byTooltip(AppStrings.ubah));
    await waitFor(find.byType(TextFormField));
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller?.text,
      'Makan',
    );
    await tester.enterText(find.byType(TextFormField), 'Makanan');
    await tester.runAsync(() async {
      await tester.tap(find.text(AppStrings.simpan));
    });
    await waitFor(find.text(AppStrings.kategoriDiperbarui));
    await waitFor(find.text('Makanan'));

    await tester.tap(find.byTooltip(AppStrings.hapus));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.batal));
    await tester.pumpAndSettle();
    expect(find.text('Makanan'), findsOneWidget);

    final transactionId = await tester.runAsync(() async {
      final database = DatabaseHelper.instance;
      final category = (await database.getAllKategori()).single;
      final walletId = await database.insertDompet(const Dompet(nama: 'Tunai'));
      return database.insertTransaksi(
        Transaksi(
          dompetId: walletId,
          kategoriId: category.id!,
          jumlah: 1000,
          tanggal: '2026-11-26',
        ),
      );
    });
    await tester.runAsync(() async {
      await tester.tap(find.byTooltip(AppStrings.hapus));
      await tester.pumpAndSettle();
      await tester.tap(find.text(AppStrings.hapus));
    });
    await waitFor(find.text(AppStrings.kategoriTidakBisaDihapus));
    await tester.tap(find.text(AppStrings.mengerti));
    await tester.pumpAndSettle();
    await tester.runAsync(() async {
      await DatabaseHelper.instance.deleteTransaksi(transactionId!);
    });
    await tester.pumpAndSettle();
    expect(find.text('Makanan'), findsOneWidget);

    await tester.runAsync(() async {
      await tester.tap(find.byTooltip(AppStrings.hapus));
      await tester.pumpAndSettle();
      await tester.tap(find.text(AppStrings.hapus));
    });
    await waitFor(find.text(AppStrings.belumAdaKategori));
    expect(find.text('Makanan'), findsNothing);
    await waitFor(find.text(AppStrings.kategoriDihapus));
  });
}
