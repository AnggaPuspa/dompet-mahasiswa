import 'package:dompet_mahasiswa/pages/main_shell.dart';
import 'package:dompet_mahasiswa/theme/app_theme.dart';
import 'package:dompet_mahasiswa/utils/app_strings.dart';
// Paket pengganti material_ui belum ada di SDK ini. development punya info yang sama.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';

void main() {
  // Database tidak dibuka di sini. Koneksi baru dibuat saat data pertama diminta.
  runApp(const DompetMahasiswaApp());
}

class DompetMahasiswaApp extends StatelessWidget {
  const DompetMahasiswaApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Shell adalah layar awal. Form dibuka sebagai rute di atasnya.
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const MainShell(),
    );
  }
}
