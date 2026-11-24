import 'package:dompet_mahasiswa/domain/value_objects/jenis_kategori.dart';

class Kategori {
  // Jenis dicek di sini, bukan dengan CHECK di SQL.
  // Typo yang lolos akan membuat saldo menghitungnya sebagai nol
  // (CASE tidak cocok) tanpa ada error.
  Kategori({this.id, required this.nama, required String jenis})
    : jenis = JenisKategori.parse(jenis).value;

  final int? id;
  final String nama;
  final String jenis;

  // Mengubah kategori menjadi map kolom sqlite.
  Map<String, Object?> toMap() {
    // Sama seperti Dompet.toMap: id null tidak ikut, supaya update tidak
    // menimpa primary key dengan null.
    return {if (id != null) 'id': id, 'nama': nama, 'jenis': jenis};
  }

  // Membaca satu baris query. Jenis dicek lagi lewat konstruktor.
  factory Kategori.fromMap(Map<String, Object?> map) {
    return Kategori(
      id: map['id'] as int?,
      nama: map['nama'] as String,
      jenis: map['jenis'] as String,
    );
  }
}
