import 'package:dompet_mahasiswa/pages/kategori_list_page.dart';
import 'package:dompet_mahasiswa/theme/app_theme.dart';
import 'package:dompet_mahasiswa/utils/app_strings.dart';
import 'package:flutter/material.dart';

void main() {
  // Database tidak dibuka di sini. Koneksi baru dibuat saat data pertama diminta.
  runApp(const DompetMahasiswaApp());
}

class DompetMahasiswaApp extends StatelessWidget {
  const DompetMahasiswaApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MainShell akan memasang halaman ini sebagai tab Kategori.
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const KategoriListPage(),
    );
  }
}
