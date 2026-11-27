import 'dart:io';

import 'package:dompet_mahasiswa/database/database_helper.dart';
import 'package:dompet_mahasiswa/domain/entities/kategori.dart';
import 'package:dompet_mahasiswa/pages/kategori_form_page.dart';
import 'package:dompet_mahasiswa/theme/app_colors.dart';
import 'package:dompet_mahasiswa/theme/app_text_styles.dart';
import 'package:dompet_mahasiswa/utils/app_strings.dart';
import 'package:dompet_mahasiswa/widgets/app_back_button.dart';
import 'package:dompet_mahasiswa/widgets/app_button.dart';
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
    directory = Directory.systemTemp.createTempSync('kategori_form_');
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

  Future<void> pumpForm(WidgetTester tester, {int? id}) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(375, 812);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.runAsync(loadProofFonts);
    await tester.runAsync(
      () => tester.pumpWidget(
        MaterialApp(
          home: RepaintBoundary(
            key: const Key('proof-form'),
            child: KategoriFormPage(id: id),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  Future<void> waitFor(WidgetTester tester, Finder finder) async {
    for (var attempt = 0; attempt < 50; attempt++) {
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

  testWidgets('form tambah menampilkan header, radio, dan tombol bawah', (
    tester,
  ) async {
    await pumpForm(tester);

    expect(find.text(AppStrings.tambahKategori), findsOneWidget);
    expect(find.text(AppStrings.jenisKategori), findsOneWidget);
    expect(find.text(AppStrings.pemasukan), findsOneWidget);
    expect(find.text(AppStrings.pengeluaran), findsOneWidget);
    expect(find.byType(AppBackButton), findsOneWidget);
    expect(find.text(AppStrings.simpan), findsOneWidget);
    expect(find.byTooltip(AppStrings.kembali), findsOneWidget);
    await settleAssets(tester);
    await captureFinder(
      tester,
      find.byKey(const Key('proof-form')),
      'kategori-form-add',
    );

    await tester.tap(find.text(AppStrings.simpan));
    await tester.pump();
    expect(find.text(AppStrings.namaKategoriWajib), findsOneWidget);
    expect(find.text(AppStrings.jenisKategoriWajib), findsOneWidget);

    final label = tester.widget<Text>(find.text(AppStrings.namaKategori));
    expect(label.style?.color, AppColors.danger);

    await settleAssets(tester);
    await captureFinder(
      tester,
      find.byKey(const Key('proof-form')),
      'kategori-form-error',
    );
  });

  testWidgets('memilih pengeluaran lalu menyimpan kategori baru', (
    tester,
  ) async {
    await pumpForm(tester);

    await tester.enterText(find.byType(TextFormField), 'Kuota & Pulsa');
    await tester.tap(find.text(AppStrings.pengeluaran));
    await tester.pump();

    final selected = tester.widget<Text>(find.text(AppStrings.pengeluaran));
    expect(selected.style?.color, AppColors.primary);
    expect(selected.style?.fontWeight, AppTextStyles.bodyStrong.fontWeight);
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump();
    await settleAssets(tester);
    await captureFinder(
      tester,
      find.byKey(const Key('proof-form')),
      'kategori-form-filled',
    );

    await tester.runAsync(() async {
      await tester.tap(find.text(AppStrings.simpan));
    });
    await waitFor(tester, find.text(AppStrings.kategoriDisimpan));

    final saved =
        await tester.runAsync(() => DatabaseHelper.instance.getAllKategori()) ??
        [];
    expect(saved, hasLength(1));
    expect(saved.single.nama, 'Kuota & Pulsa');
    expect(saved.single.jenis, AppStrings.pengeluaran);
  });

  testWidgets('form ubah memuat nama dan jenis yang tersimpan', (tester) async {
    final id = await tester.runAsync(() async {
      final created = await DatabaseHelper.instance.insertKategori(
        Kategori(nama: 'Kuota & Pulsa', jenis: AppStrings.pengeluaran),
      );
      await DatabaseHelper.reset();
      return created;
    });
    await pumpForm(tester, id: id);
    await waitFor(tester, find.text(AppStrings.ubahKategori));

    expect(find.text(AppStrings.ubahKategori), findsOneWidget);
    expect(find.text('Kuota & Pulsa'), findsOneWidget);
    final selected = tester.widget<Text>(find.text(AppStrings.pengeluaran));
    expect(selected.style?.color, AppColors.primary);
    expect(find.byType(AppButton), findsOneWidget);

    await settleAssets(tester);
    await captureFinder(
      tester,
      find.byKey(const Key('proof-form')),
      'kategori-form-edit',
    );
  });
}
