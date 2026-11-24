import 'package:dompet_mahasiswa/domain/entities/kategori.dart';
import 'package:dompet_mahasiswa/domain/value_objects/jenis_kategori.dart';

abstract interface class KategoriRepository {
  // Menyimpan kategori. Mengembalikan id baru.
  Future<int> tambah(Kategori data);

  // Mengganti kategori yang sudah punya id.
  Future<int> ubah(Kategori data);

  // Menghapus kategori. Mengembalikan jumlah baris terhapus.
  Future<int> hapus(int id);

  // Semua kategori. List kosong bila belum ada data.
  Future<List<Kategori>> semua();

  // Satu kategori, atau null bila tidak ada.
  Future<Kategori?> cari(int id);

  // Hanya kategori dengan jenis yang diberikan. List kosong bila tidak ada.
  Future<List<Kategori>> berdasarkanJenis(JenisKategori jenis);
}
