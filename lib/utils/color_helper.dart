import 'package:dompet_mahasiswa/domain/value_objects/jenis_kategori.dart';
import 'package:dompet_mahasiswa/theme/app_colors.dart';
import 'package:flutter/material.dart';

Color colorForJenis(String jenis) {
  return switch (JenisKategori.parse(jenis)) {
    JenisKategori.pemasukan => AppColors.success,
    JenisKategori.pengeluaran => AppColors.danger,
  };
}

/// Warna teks badge jenis. Pemasukan memakai hijau yang lebih pekat
/// daripada [colorForJenis], sesuai Badge di Figma.
Color foregroundForJenis(String jenis) {
  return switch (JenisKategori.parse(jenis)) {
    JenisKategori.pemasukan => AppColors.successStrong,
    JenisKategori.pengeluaran => AppColors.danger,
  };
}

/// Latar lembut untuk badge dan kartu. Pasangan dari [colorForJenis].
Color backgroundForJenis(String jenis) {
  return switch (JenisKategori.parse(jenis)) {
    JenisKategori.pemasukan => AppColors.successTint,
    JenisKategori.pengeluaran => AppColors.dangerTint,
  };
}
