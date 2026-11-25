import 'package:dompet_mahasiswa/domain/value_objects/jenis_kategori.dart';
import 'package:dompet_mahasiswa/theme/app_colors.dart';
import 'package:flutter/material.dart';

Color colorForJenis(String jenis) {
  return switch (JenisKategori.parse(jenis)) {
    JenisKategori.pemasukan => AppColors.success,
    JenisKategori.pengeluaran => AppColors.danger,
  };
}
