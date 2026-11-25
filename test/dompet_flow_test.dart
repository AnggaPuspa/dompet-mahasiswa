import 'dart:io';

import 'package:dompet_mahasiswa/database/database_helper.dart';
import 'package:dompet_mahasiswa/domain/entities/dompet.dart';
import 'package:dompet_mahasiswa/domain/entities/kategori.dart';
import 'package:dompet_mahasiswa/domain/entities/transaksi.dart';
import 'package:dompet_mahasiswa/pages/dompet_list_page.dart';
import 'package:dompet_mahasiswa/utils/app_strings.dart';
import 'package:dompet_mahasiswa/utils/currency_format.dart';
import 'package:dompet_mahasiswa/widgets/app_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late Directory storage;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfiNoIsolate;
  });

  setUp(() async {
    storage = await Directory.systemTemp.createTemp('dompet_flow_');
    DatabaseHelper.pathResolver = () async => join(storage.path, 'dompet.db');
    await DatabaseHelper.instance.getAllDompet();
  });

  tearDown(() async {
    await DatabaseHelper.reset();
    DatabaseHelper.pathResolver = DatabaseHelper.lokasiBawaan;
    await storage.delete(recursive: true);
  });

  testWidgets('tambah, ubah, batal hapus, dan hapus dompet', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: DompetListPage()));
    final tambah = find.text(AppStrings.tambahDompet);
    await _tungguWidget(tester, tambah);
    await tester.tap(tambah);
    await tester.pumpAndSettle();

    final simpan = find.text(AppStrings.simpan);
    await tester.tap(simpan);
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.namaDompetWajib), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), '  Tunai  ');
    await tester.tap(simpan);
    final tunai = find.widgetWithText(AppCard, 'Tunai');
    await _tungguWidget(tester, tunai);
    expect(find.text(formatRupiah(0)), findsOneWidget);

    await tester.tap(tunai);
    final field = find.byType(TextFormField);
    await _tungguWidget(tester, field);
    expect(tester.widget<TextFormField>(field).controller?.text, 'Tunai');
    await tester.enterText(field, 'Kartu');
    await tester.tap(simpan);
    final kartu = find.widgetWithText(AppCard, 'Kartu');
    await _tungguWidget(tester, kartu);

    final hapus = find.byTooltip(AppStrings.hapus);
    await tester.tap(hapus);
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.batal));
    await tester.pumpAndSettle();
    expect(kartu, findsOneWidget);

    await tester.tap(hapus);
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.hapus));
    await _tungguWidget(tester, find.text(AppStrings.belumAdaDompet));
  });

  testWidgets('saldo ditampilkan dan dompet terpakai tidak dihapus', (
    tester,
  ) async {
    await tester.runAsync(() async {
      final db = DatabaseHelper.instance;
      final dompetId = await db.insertDompet(const Dompet(nama: 'Bank'));
      final kategoriId = await db.insertKategori(
        Kategori(nama: 'Gaji', jenis: 'Pemasukan'),
      );
      await db.insertTransaksi(
        Transaksi(
          dompetId: dompetId,
          kategoriId: kategoriId,
          jumlah: 50000,
          tanggal: '2026-11-25',
        ),
      );
    });

    await tester.pumpWidget(const MaterialApp(home: DompetListPage()));
    await _tungguWidget(tester, find.text(formatRupiah(50000)));
    await tester.tap(find.byTooltip(AppStrings.hapus));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.hapus));
    await _tungguWidget(tester, find.text(AppStrings.dompetTidakBisaDihapus));
    expect(find.text('Bank'), findsOneWidget);
  });
}

Future<void> _tungguWidget(WidgetTester tester, Finder finder) async {
  for (var percobaan = 0; percobaan < 300; percobaan++) {
    await tester.pump(const Duration(milliseconds: 16));
    if (finder.evaluate().isNotEmpty) {
      await tester.pump(const Duration(milliseconds: 350));
      if (finder.evaluate().isNotEmpty) return;
    }
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 10)),
    );
  }
  expect(finder, findsOneWidget);
}
