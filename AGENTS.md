# AGENTS.md

## Ringkasan

Dompet Mahasiswa mencatat pemasukan, pengeluaran, dan saldo. Stack repo kita, dari `pubspec.yaml`: Flutter SDK, Dart `^3.12.0`, `sqflite: ^2.4.6`, `flutter_svg: ^2.5.1`, `lottie: ^3.8.2`.

## Perintah

Pakai perintah ini dari root repo:

```bash
flutter pub get
flutter analyze
flutter test
flutter test test/<file>_test.dart
dart format .
flutter run
```

Analisis dan tes selalu lewat Flutter. Jangan pakai `dart analyze` atau `dart test`. Satu berkas: ganti pola di atas, misalnya `flutter test test/database_helper_test.dart`. `flutter analyze` harus bersih (0 issue) sebelum push.

## Peta layer

Halaman di `lib/pages/`:

- `main_shell.dart` — `MainShell`, `ShellNavigationBar`
- `dashboard_page.dart` — `DashboardPage`
- `dompet_form_page.dart` — `DompetFormPage`
- `kategori_list_page.dart` — `KategoriListPage`
- `kategori_form_page.dart` — `KategoriFormPage`

Widget bersama di `lib/widgets/`. Impor berkasnya langsung (`package:dompet_mahasiswa/widgets/app_button.dart`). `lib/widgets/widgets.dart` tidak mengekspor `AppButton`, `AppTextField`, `AppCard`, `EmptyState`, `ConfirmDialog`, atau `AppBackButton`.

Model `Dompet`, `Kategori`, `Transaksi`, dan `TransaksiItem` ada di `lib/domain/entities/`. `lib/models/dompet.dart`, `kategori.dart`, `transaksi.dart`, dan `transaksi_item.dart` hanya mengekspor kelas yang sama. Halaman mengimpor entity, misalnya `package:dompet_mahasiswa/domain/entities/kategori.dart`.

Semua baca/tulis dari UI lewat `DatabaseHelper.instance` di `lib/database/database_helper.dart`. Berkas SQLite: `dompet_mahasiswa.db` (`namaBerkasDatabase`). Skema `version: 1` di `AppDatabase` (`lib/infrastructure/persistence/app_database.dart`).

Token di `lib/theme/`: `AppColors`, `AppTextStyles`, `AppSpacing`, `AppRadius`, `AppShadows`, `AppTheme`.

Teks pengguna: `AppStrings` di `lib/utils/app_strings.dart`.

Rupiah: `formatRupiah` di `lib/utils/currency_format.dart`. Tanggal: `formatTanggal`, `formatBulanTahun`, `formatBulanTahunPendek` di `lib/utils/date_format.dart` (berkas yang sama juga punya `toIsoDate`, `toYearMonth`, dan `parseIsoDate`).

Aset lewat `AppAssets` (`lib/utils/app_assets.dart`): SVG di `assets/icons/`, Lottie `assets/lottie/empty_state.json`, font Lexend Deca (`AppTextStyles.fontFamily`) di `assets/fonts/` (Regular 400, Medium 500, SemiBold 600, Bold 700).

## Konvensi UI

Pakai token dan widget yang sudah ada. Jangan hardcode warna, jarak, radius, atau string.

- Warna hanya `AppColors`. `Color(0xFF...)` hanya boleh di `lib/theme/app_colors.dart`.
- Jenis pemasukan/pengeluaran lewat `colorForJenis`. Teks badge `foregroundForJenis`, latar `backgroundForJenis` (`lib/utils/color_helper.dart`).
- Jarak `AppSpacing` (`s16`, `pad16`, `horizontal20`). Radius `AppRadius` (`mdAll`, `buttonAll`). Bayangan `AppShadows`.
- Huruf `AppTextStyles`. Ganti warna dengan `copyWith(color: AppColors....)`, seperti di `DashboardPage`. Jangan menulis `TextStyle(fontSize: ...)` baru.
- Tombol `AppButton`, field `AppTextField`, kartu `AppCard`, kosong `EmptyState`, konfirmasi `ConfirmDialog.show`, kembali `AppBackButton`. Pilihan jenis: `AppJenisField`.
- Snackbar: `showSuccessSnackbar`, `showErrorSnackbar`, `showInfoSnackbar` di `lib/utils/snackbar_helper.dart`. Jangan panggil `ScaffoldMessenger` dari halaman.
- Kalimat yang pengguna lihat hanya dari `AppStrings`.
- Nominal hanya `formatRupiah` (negatif tetap `-Rp 1.000`). Tanggal tampilan hanya formatter di `lib/utils/date_format.dart`.

```dart
Color colorForJenis(String jenis) {
  return switch (JenisKategori.parse(jenis)) {
    JenisKategori.pemasukan => AppColors.success,
    JenisKategori.pengeluaran => AppColors.danger,
  };
}
```

`JenisKategori` (`lib/domain/value_objects/jenis_kategori.dart`) hanya mengenal teks `Pemasukan` dan `Pengeluaran`.

UI mengikuti Figma kita: https://www.figma.com/design/nwP2fwOyQukCjqHev21ReF. Kalau kode dan Figma beda, Figma yang menang. Samakan lewat token yang sudah ada, jangan menaruh angka desain langsung di widget.

## Konvensi kode

Impor UI dengan `package:flutter/material.dart`. Jangan migrasi ke `material_ui`. Jangan menambah `// ignore: deprecated_member_use` baru. Theme aplikasi memakai `AppTheme.light()` (`useMaterial3: true` di `lib/theme/app_theme.dart`). Halaman tidak membuat `ThemeData` sendiri.

Bangun widget `const` bila argumennya const. `lib/main.dart` memakai `home: const MainShell()`.

Buang setiap `TextEditingController` di `dispose`. `KategoriFormPage` membuang `_name` lalu memanggil `super.dispose()`.

Setelah `await`, cek `mounted` sebelum `setState`, `Navigator`, atau snackbar.

Jangan query SQLite di widget. Akses data lewat `DatabaseHelper`. Jangan mengimpor `sqflite` dari `lib/pages/` atau `lib/widgets/`.

Sebelum hapus, cek pemakaian. `isDompetUsedInTransaksi` untuk dompet, `isKategoriUsedInTransaksi` untuk kategori. Keduanya true bila masih ada transaksi. Foreign key menolak hapus yang masih dirujuk; layar harus menolak lebih dulu dan memberitahu pengguna.

```dart
if (!mounted || !confirmed) return;
if (await _database.isKategoriUsedInTransaksi(id)) {
  if (mounted) await _showTidakBisaDihapus();
  return;
}
```

Potongan itu dari `KategoriListPage._delete`. Hapus dompet memakai `isDompetUsedInTransaksi` dengan urutan yang sama, sebelum `deleteDompet`.

Null safety wajib. Jangan pakai `dynamic`, dan jangan pakai `!` pada nilai yang belum dicek. Nama berkas `snake_case` (`kategori_list_page.dart`). Nama kelas `PascalCase` (`KategoriListPage`).

## Testing

Tes di `test/`. Database: `test/database_helper_test.dart`. Formatter: `test/formatters_test.dart`. Halaman: `test/pages/`. Widget: `test/widgets/`.

Tes yang membuka SQLite memakai `sqflite_common_ffi`. Tes widget yang menyentuh database mengikuti `test/pages/kategori_list_page_test.dart`:

```dart
setUpAll(() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfiNoIsolate;
  silenceDatabaseLockWarning();
});
```

`silenceDatabaseLockWarning` ada di `test/support/sqlite_setup.dart`. Panggil itu supaya timer kunci sqflite tidak menggantung di `FakeAsync` saat tes memakai `WidgetTester.runAsync`.

`test/database_helper_test.dart` memakai `databaseFactoryFfi` karena bukan tes widget, dan tidak memanggil `silenceDatabaseLockWarning`.

Di `setUp`, arahkan `DatabaseHelper.pathResolver` ke berkas sementara, lalu `await DatabaseHelper.reset()`. Di `tearDown`, `reset` lagi dan kembalikan `DatabaseHelper.pathResolver = DatabaseHelper.lokasiBawaan`.

Setiap ubah logika, tambah atau ubah tes yang mengunci perilaku itu. Jalankan berkasnya dengan `flutter test test/<file>_test.dart`, lalu `flutter test`.

## Git flow

Satu issue, satu branch, dari `development`:

```bash
git checkout development
git pull origin development
git checkout -b feat/<nomor-issue>-<slug>
```

Buka PR ke `development`. Jangan membuka PR ke `main`. Body PR memuat baris `Closes #N` (nomor issue yang diselesaikan).

Pesan commit conventional, satu jenis: `feat`, `fix`, `chore`, `refactor`, `test`, atau `docs`. Contoh: `feat: samakan daftar kategori dengan Figma`.

Rilis `development` ke `main` kita lakukan lewat PR rilis terpisah. Jangan membuat PR ke `main`, dan jangan merge PR ke `main`.

## Batasan

Selalu:

- Jalankan `flutter analyze` dan `flutter test` sebelum push. Keduanya harus lolos.
- Ikuti acceptance criteria issue. Kerjakan hanya yang issue itu minta.

Tanya dulu:

- Menambah package di `pubspec.yaml`.
- Mengubah skema tabel atau menaikkan `version` di `AppDatabase`.
- Mengubah widget global di `lib/widgets/` atau token di `lib/theme/`.
- Mengubah berkas di luar scope issue.

Jangan pernah:

- Push langsung ke `main` atau `development`.
- Force push ke branch orang lain.
- Commit secret atau berkas `.env`.
- Menghapus tes, melewati assertion, atau melemahkan ekspektasi supaya lolos.
