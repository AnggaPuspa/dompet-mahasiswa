import 'package:dompet_mahasiswa/domain/entities/dompet.dart';
import 'package:dompet_mahasiswa/domain/repositories/dompet_repository.dart';

class KelolaDompet {
  // CRUD dompet hanya lewat repository dompet.
  KelolaDompet(this.dompet);

  final DompetRepository dompet;

  // Menyimpan dompet dan mengembalikan id baru.
  Future<int> tambah(Dompet data) => dompet.tambah(data);

  // Mengganti dompet. Butuh id; kalau null, penyimpanan menolaknya.
  Future<int> ubah(Dompet data) => dompet.ubah(data);

  // Menghapus dompet. Gagal bila masih ada transaksi yang merujuknya.
  Future<int> hapus(int id) => dompet.hapus(id);

  // Semua dompet. List kosong, bukan error, bila tabel masih kosong.
  Future<List<Dompet>> semua() => dompet.semua();

  // Satu dompet, atau null bila id tidak ada.
  Future<Dompet?> cari(int id) => dompet.cari(id);
}
