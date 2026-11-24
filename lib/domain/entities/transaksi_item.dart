// Nama dompet dan kategori tidak disalin ke tabel transaksi.
// Kalau disalin, mengganti nama dompet tidak akan kelihatan di riwayat lama.
class TransaksiItem {
  const TransaksiItem({
    this.id,
    required this.dompetId,
    required this.kategoriId,
    required this.jumlah,
    required this.tanggal,
    this.catatan,
    required this.namaDompet,
    required this.namaKategori,
    required this.jenisKategori,
  });

  final int? id;
  final int dompetId;
  final int kategoriId;
  final int jumlah;
  final String tanggal;
  final String? catatan;
  final String namaDompet;
  final String namaKategori;
  final String jenisKategori;

  // Membaca baris hasil join. Nama diambil dari alias nama_dompet, nama_kategori, jenis_kategori.
  factory TransaksiItem.fromMap(Map<String, Object?> map) {
    return TransaksiItem(
      id: map['id'] as int?,
      dompetId: map['dompet_id'] as int,
      kategoriId: map['kategori_id'] as int,
      jumlah: map['jumlah'] as int,
      tanggal: map['tanggal'] as String,
      catatan: map['catatan'] as String?,
      namaDompet: map['nama_dompet'] as String,
      namaKategori: map['nama_kategori'] as String,
      jenisKategori: map['jenis_kategori'] as String,
    );
  }
}
