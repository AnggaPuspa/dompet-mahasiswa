import 'dart:io';

import 'package:dompet_mahasiswa/database/database_helper.dart';
import 'package:dompet_mahasiswa/domain/entities/dompet.dart';
import 'package:dompet_mahasiswa/domain/entities/kategori.dart';
import 'package:dompet_mahasiswa/domain/entities/transaksi.dart';
import 'package:dompet_mahasiswa/main.dart';
import 'package:dompet_mahasiswa/pages/dashboard_page.dart';
import 'package:dompet_mahasiswa/theme/app_theme.dart';
import 'package:dompet_mahasiswa/utils/app_strings.dart';
import 'package:dompet_mahasiswa/utils/currency_format.dart';
import 'package:dompet_mahasiswa/utils/date_format.dart';
import 'package:dompet_mahasiswa/widgets/hero_card.dart';
import 'package:dompet_mahasiswa/widgets/wallet_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../support/capture.dart';
import '../support/proof_fonts.dart';
import '../support/sqlite_setup.dart';

void main() {
  setUp(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfiNoIsolate;
    silenceDatabaseLockWarning();
  });

  testWidgets('dashboard terisi dari database', (tester) async {
    final directory = await _openDatabase();
    addTearDown(() => _closeDatabase(directory));
    _usePhone(tester);

    await tester.runAsync(loadProofFonts);
    await tester.runAsync(() => _seedLedger(DatabaseHelper.instance));
    await tester.runAsync(
      () => tester.pumpWidget(
        const RepaintBoundary(
          key: Key('capture-root'),
          child: DompetMahasiswaApp(),
        ),
      ),
    );
    await _waitFor(tester, find.text('Makan & Minum'));

    expect(
      find.text(AppStrings.totalNominal(formatRupiah(3475000))),
      findsOneWidget,
    );
    expect(
      find.text(
        AppStrings.labelNominal(AppStrings.pemasukan, formatRupiah(2500000)),
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        AppStrings.labelNominal(AppStrings.pengeluaran, formatRupiah(1240000)),
      ),
      findsOneWidget,
    );
    expect(find.text('50%'), findsOneWidget);
    expect(find.text('Tunai'), findsOneWidget);
    expect(find.text(formatRupiah(350000)), findsOneWidget);
    expect(find.text('Bank BRI'), findsOneWidget);
    expect(find.text(formatRupiah(2450000)), findsOneWidget);

    await _settleAssets(tester);
    await captureFinder(
      tester,
      find.byKey(const Key('capture-root')),
      'dashboard-loaded',
    );
    await captureFinder(
      tester,
      find.byKey(const Key('shell-navigation-bar')),
      'navbar',
    );

    await tester.drag(
      find.descendant(
        of: find.byKey(const Key('daftar-dompet')),
        matching: find.byType(Scrollable),
      ),
      const Offset(-WalletCard.frameWidth * 2, 0),
    );
    await tester.pump();
    expect(find.text('GoPay'), findsOneWidget);
    expect(find.text(formatRupiah(675000)), findsOneWidget);
    expect(
      find.text(AppStrings.nominalBulanIni(formatRupiah(650000))),
      findsOneWidget,
    );
    expect(find.text('52%'), findsOneWidget);
    expect(find.text('Transportasi'), findsOneWidget);
    expect(find.text('26%'), findsOneWidget);
    expect(find.text('Kuota & Pulsa'), findsOneWidget);
    expect(find.text('12%'), findsOneWidget);
    expect(find.text('Lainnya'), findsNothing);
    expect(
      find.text(
        AppStrings.budgetTerpakaiBulan(formatBulanTahunPendek(DateTime.now())),
      ),
      findsOneWidget,
    );

    await tester.tap(find.text(AppStrings.lihatRiwayat));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text(AppStrings.halamanBelumSiap), findsOneWidget);
    expect(find.widgetWithText(AppBar, AppStrings.riwayat), findsOneWidget);
  });

  testWidgets('dashboard kosong menampilkan EmptyState', (tester) async {
    final directory = await _openDatabase();
    addTearDown(() => _closeDatabase(directory));
    _usePhone(tester);

    await tester.runAsync(loadProofFonts);
    await tester.runAsync(
      () => tester.pumpWidget(
        const RepaintBoundary(
          key: Key('capture-root'),
          child: DompetMahasiswaApp(),
        ),
      ),
    );
    await _waitFor(tester, find.text(AppStrings.belumAdaData));

    expect(find.text(AppStrings.pesanDashboardKosong), findsOneWidget);
    expect(find.byType(HeroCard), findsNothing);
    expect(find.text(AppStrings.gagalMemuatDashboard), findsNothing);
    await _settleAssets(tester);
    await captureFinder(
      tester,
      find.byKey(const Key('capture-root')),
      'dashboard-empty',
    );
  });

  testWidgets('dashboard gagal memuat lalu bisa coba lagi', (tester) async {
    final directory = Directory.systemTemp.createTempSync('dash_err_');
    var fail = true;
    DatabaseHelper.pathResolver = () async {
      if (fail) {
        throw StateError('database tidak siap');
      }
      return path.join(directory.path, 'test.db');
    };
    await DatabaseHelper.reset();
    addTearDown(() => _closeDatabase(directory));
    _usePhone(tester);

    await tester.runAsync(loadProofFonts);
    await tester.runAsync(
      () => tester.pumpWidget(
        RepaintBoundary(
          key: const Key('capture-root'),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            home: const DashboardPage(),
          ),
        ),
      ),
    );
    await _waitFor(tester, find.text(AppStrings.cobaLagi));

    expect(find.text(AppStrings.gagalMemuatDashboard), findsWidgets);
    expect(find.text(AppStrings.belumAdaData), findsNothing);
    await _settleAssets(tester);
    await captureFinder(
      tester,
      find.byKey(const Key('capture-root')),
      'dashboard-error',
    );

    fail = false;
    await tester.runAsync(() async {
      await tester.tap(find.text(AppStrings.cobaLagi));
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await _waitFor(tester, find.text(AppStrings.belumAdaData));
    expect(find.text(AppStrings.pesanDashboardKosong), findsOneWidget);
    expect(find.text(AppStrings.cobaLagi), findsNothing);
  });

  testWidgets('ada dompet tanpa pengeluaran bulan ini', (tester) async {
    final directory = await _openDatabase();
    addTearDown(() => _closeDatabase(directory));
    _disableMotion(tester);

    final dompetId = await tester.runAsync(() async {
      final database = DatabaseHelper.instance;
      final dompet = await database.insertDompet(const Dompet(nama: 'Tunai'));
      final pemasukan = await database.insertKategori(
        Kategori(nama: 'Uang Saku', jenis: 'Pemasukan'),
      );
      await database.insertTransaksi(
        Transaksi(
          dompetId: dompet,
          kategoriId: pemasukan,
          jumlah: 80000,
          tanggal: toIsoDate(DateTime.now()),
        ),
      );
      return dompet;
    });
    expect(dompetId, isNotNull);

    await tester.runAsync(
      () => tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          home: const DashboardPage(),
        ),
      ),
    );
    await _waitFor(tester, find.text('Tunai'));

    expect(find.text(AppStrings.belumAdaData), findsNothing);
    expect(find.text(AppStrings.belumAdaPengeluaranBulanIni), findsOneWidget);
    expect(
      find.text(
        AppStrings.labelNominal(AppStrings.pemasukan, formatRupiah(80000)),
      ),
      findsOneWidget,
    );
    expect(
      find.text(AppStrings.totalNominal(formatRupiah(80000))),
      findsOneWidget,
    );
    expect(find.text('0%'), findsOneWidget);
  });
}

Future<Directory> _openDatabase() async {
  final directory = Directory.systemTemp.createTempSync('dash_');
  DatabaseHelper.pathResolver = () async {
    return path.join(directory.path, 'test.db');
  };
  await DatabaseHelper.reset();
  return directory;
}

Future<void> _closeDatabase(Directory directory) async {
  await DatabaseHelper.reset();
  DatabaseHelper.pathResolver = DatabaseHelper.lokasiBawaan;
  if (directory.existsSync()) {
    directory.deleteSync(recursive: true);
  }
}

void _usePhone(WidgetTester tester) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(375, 812);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void _disableMotion(WidgetTester tester) {
  final dispatcher = tester.binding.platformDispatcher;
  dispatcher.accessibilityFeaturesTestValue = const FakeAccessibilityFeatures(
    disableAnimations: true,
  );
  addTearDown(dispatcher.clearAccessibilityFeaturesTestValue);
}

Future<void> _seedLedger(DatabaseHelper database) async {
  final now = DateTime.now();
  final bulanIni = toIsoDate(now);
  final bulanLalu = toIsoDate(DateTime(now.year, now.month - 1, 15));
  final tunai = await database.insertDompet(const Dompet(nama: 'Tunai'));
  final bri = await database.insertDompet(const Dompet(nama: 'Bank BRI'));
  final gopay = await database.insertDompet(const Dompet(nama: 'GoPay'));
  final saku = await database.insertKategori(
    Kategori(nama: 'Uang Saku', jenis: 'Pemasukan'),
  );
  final makan = await database.insertKategori(
    Kategori(nama: 'Makan & Minum', jenis: 'Pengeluaran'),
  );
  final transport = await database.insertKategori(
    Kategori(nama: 'Transportasi', jenis: 'Pengeluaran'),
  );
  final pulsa = await database.insertKategori(
    Kategori(nama: 'Kuota & Pulsa', jenis: 'Pengeluaran'),
  );
  final lain = await database.insertKategori(
    Kategori(nama: 'Lainnya', jenis: 'Pengeluaran'),
  );

  Future<void> catat(int dompet, int kategori, int jumlah, String tanggal) {
    return database.insertTransaksi(
      Transaksi(
        dompetId: dompet,
        kategoriId: kategori,
        jumlah: jumlah,
        tanggal: tanggal,
      ),
    );
  }

  await catat(tunai, saku, 620000, bulanLalu);
  await catat(bri, lain, 50000, bulanLalu);
  await catat(gopay, saku, 1645000, bulanLalu);
  await catat(bri, saku, 2500000, bulanIni);
  await catat(gopay, makan, 650000, bulanIni);
  await catat(gopay, transport, 320000, bulanIni);
  await catat(tunai, pulsa, 150000, bulanIni);
  await catat(tunai, lain, 120000, bulanIni);
}

Future<void> _settleAssets(WidgetTester tester) async {
  for (var attempt = 0; attempt < 20; attempt++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pump(const Duration(milliseconds: 100));
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
