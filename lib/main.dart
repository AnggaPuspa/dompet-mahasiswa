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
    // Layar awal saja. Navigasi dan halaman lain menggantikan home ini nanti.
    return MaterialApp(
      title: AppStrings.appName,
      theme: AppTheme.light(),
      home: const Scaffold(
        body: Center(child: Text(AppStrings.placeholderBody)),
      ),
    );
  }
}
