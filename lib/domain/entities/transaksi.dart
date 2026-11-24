class Transaksi {
  const Transaksi({
    this.id,
    required this.dompetId,
    required this.kategoriId,
    required this.jumlah,
    required this.tanggal,
    this.catatan,
  });

  final int? id;
  final int dompetId;
  final int kategoriId;

  // int, bukan double. Uang dalam floating point bergeser (0.1 + 0.2),
  // dan saldo yang dijumlahkan berkali-kali akan meleset.
  final int jumlah;

  // Teks yyyy-MM-dd, bukan DateTime. Kolom SQLite tidak punya tipe tanggal,
  // dan DateTime membawa jam serta zona yang tidak dipakai di sini.
  final String tanggal;
  final String? catatan;

  // Mengubah transaksi menjadi map kolom sqlite.
  Map<String, Object?> toMap() {
    // catatan tetap dikirim meski null, supaya update bisa mengosongkan catatan.
    // id null tidak dikirim; alasan sama dengan Dompet.toMap.
    return {
      if (id != null) 'id': id,
      'dompet_id': dompetId,
      'kategori_id': kategoriId,
      'jumlah': jumlah,
      'tanggal': tanggal,
      'catatan': catatan,
    };
  }

  // Membaca satu baris tabel transaksi, tanpa nama dompet atau kategori.
  factory Transaksi.fromMap(Map<String, Object?> map) {
    return Transaksi(
      id: map['id'] as int?,
      dompetId: map['dompet_id'] as int,
      kategoriId: map['kategori_id'] as int,
      jumlah: map['jumlah'] as int,
      tanggal: map['tanggal'] as String,
      catatan: map['catatan'] as String?,
    );
  }
}
