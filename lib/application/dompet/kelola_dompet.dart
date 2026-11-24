import 'package:dompet_mahasiswa/domain/entities/dompet.dart';
import 'package:dompet_mahasiswa/domain/repositories/dompet_repository.dart';
import 'package:dompet_mahasiswa/domain/repositories/transaksi_repository.dart';

class KelolaDompet {
  // "Sedang dipakai transaksi" tidak dibaca dari tabel dompet.
  // Mengeceknya di repository dompet akan membuat repository itu
  // membuka tabel transaksi. Penggabungan dua sumber ada di use case.
  KelolaDompet({required this.dompet, required this.transaksi});

  final DompetRepository dompet;
  final TransaksiRepository transaksi;

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

  // True bila tabel transaksi punya baris dengan dompet_id ini.
  Future<bool> dipakaiDiTransaksi(int id) => transaksi.adaUntukDompet(id);
}
