import 'package:dompet_mahasiswa/domain/entities/dompet.dart';

abstract interface class DompetRepository {
  // Menyimpan dompet. Mengembalikan id baru.
  Future<int> tambah(Dompet data);

  // Mengganti dompet yang sudah punya id. Mengembalikan jumlah baris berubah.
  Future<int> ubah(Dompet data);

  // Menghapus dompet. Mengembalikan jumlah baris terhapus.
  Future<int> hapus(int id);

  // Semua dompet. List kosong bila belum ada data.
  Future<List<Dompet>> semua();

  // Satu dompet, atau null bila tidak ada.
  Future<Dompet?> cari(int id);
}
