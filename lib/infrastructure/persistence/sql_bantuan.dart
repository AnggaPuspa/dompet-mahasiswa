// Mengubah hasil agregat SQLite menjadi int. Null dianggap 0.
int bacaInt(Object? nilai) {
  // SUM di SQLite bisa kembali sebagai int atau double, tergantung driver.
  // Cast `as int` pecah saat nilainya 0.0.
  if (nilai == null) {
    return 0;
  }
  if (nilai is int) {
    return nilai;
  }
  if (nilai is num) {
    return nilai.round();
  }
  throw FormatException('Nilai bilangan tidak valid: $nilai');
}

// Memastikan update punya id. Mengembalikan id bila ada.
int wajibId(int? id, String peran) {
  // Update tanpa id mengubah 0 baris dan terlihat berhasil.
  // Gagal di sini lebih jelas daripada diam-diam tidak menyimpan.
  if (id == null) {
    throw ArgumentError.value(id, 'id', 'wajib diisi saat memperbarui $peran');
  }
  return id;
}
