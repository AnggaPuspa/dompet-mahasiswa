import 'package:dompet_mahasiswa/domain/entities/kategori.dart';
import 'package:dompet_mahasiswa/domain/repositories/kategori_repository.dart';
import 'package:dompet_mahasiswa/domain/value_objects/jenis_kategori.dart';

class KelolaKategori {
  // CRUD kategori hanya membaca tabel kategori.
  KelolaKategori(this.kategori);

  final KategoriRepository kategori;

  // Menyimpan kategori dan mengembalikan id baru.
  Future<int> tambah(Kategori data) => kategori.tambah(data);

  // Mengganti nama atau jenis. Butuh id.
  Future<int> ubah(Kategori data) => kategori.ubah(data);

  // Menghapus kategori. Gagal bila masih dipakai transaksi.
  Future<int> hapus(int id) => kategori.hapus(id);

  // Semua kategori. List kosong bila belum ada data.
  Future<List<Kategori>> semua() => kategori.semua();

  // Satu kategori, atau null bila id tidak ada.
  Future<Kategori?> cari(int id) => kategori.cari(id);

  // Memilih kategori menurut jenis. Jenis dicek dulu supaya typo tidak terlihat seperti data kosong.
  Future<List<Kategori>> berdasarkanJenis(String jenis) {
    // Jenis yang salah, kalau langsung ke SQL, menghasilkan list kosong.
    // Layar akan mengira memang belum ada kategori, bukan input yang keliru.
    return kategori.berdasarkanJenis(JenisKategori.parse(jenis));
  }
}
