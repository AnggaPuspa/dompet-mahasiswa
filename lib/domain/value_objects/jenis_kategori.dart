// Nilai yang disimpan adalah teks, bukan indeks enum.
// Menyimpan 0/1 akan rusak kalau urutan nilai enum ini berubah.
enum JenisKategori {
  pemasukan('Pemasukan'),
  pengeluaran('Pengeluaran');

  const JenisKategori(this.value);

  final String value;

  // Mencocokkan teks persis 'Pemasukan' atau 'Pengeluaran'. Teks lain ditolak.
  static JenisKategori parse(String raw) {
    for (final jenis in JenisKategori.values) {
      if (jenis.value == raw) {
        return jenis;
      }
    }
    throw FormatException('Jenis kategori tidak dikenal: $raw');
  }
}
