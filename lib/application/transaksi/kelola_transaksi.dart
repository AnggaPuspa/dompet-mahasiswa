import 'package:dompet_mahasiswa/domain/entities/transaksi.dart';
import 'package:dompet_mahasiswa/domain/entities/transaksi_item.dart';
import 'package:dompet_mahasiswa/domain/queries/filter_transaksi.dart';
import 'package:dompet_mahasiswa/domain/repositories/transaksi_repository.dart';

class KelolaTransaksi {
  // Hanya berbicara ke repository transaksi. Aturan saldo tidak diputuskan di sini.
  KelolaTransaksi(this.transaksi);

  final TransaksiRepository transaksi;

  // Menyimpan transaksi dan mengembalikan id baru. Foreign key yang gagal naik apa adanya.
  Future<int> tambah(Transaksi data) => transaksi.tambah(data);

  // Mengganti transaksi yang sudah punya id.
  Future<int> ubah(Transaksi data) => transaksi.ubah(data);

  // Menghapus satu transaksi dan mengembalikan jumlah baris terhapus.
  Future<int> hapus(int id) => transaksi.hapus(id);

  // Satu transaksi, atau null. Tidak menyertakan nama dompet dan kategori.
  Future<Transaksi?> cari(int id) => transaksi.cari(id);

  // Daftar untuk layar riwayat. Null pada filter berarti bagian itu tidak disaring.
  Future<List<TransaksiItem>> daftar({String? bulan, int? kategoriId}) {
    return transaksi.daftar(
      FilterTransaksi(bulan: bulan, kategoriId: kategoriId),
    );
  }
}
