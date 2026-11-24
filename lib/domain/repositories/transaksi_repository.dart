import 'package:dompet_mahasiswa/domain/entities/transaksi.dart';
import 'package:dompet_mahasiswa/domain/entities/transaksi_item.dart';
import 'package:dompet_mahasiswa/domain/queries/filter_transaksi.dart';

abstract interface class TransaksiRepository {
  // Menyimpan transaksi. Mengembalikan id baru.
  Future<int> tambah(Transaksi data);

  // Mengganti transaksi yang sudah punya id.
  Future<int> ubah(Transaksi data);

  // Menghapus transaksi. Mengembalikan jumlah baris terhapus.
  Future<int> hapus(int id);

  // Satu transaksi tanpa nama relasi, atau null.
  Future<Transaksi?> cari(int id);

  // Daftar untuk tampilan, sudah digabung dengan nama dompet dan kategori.
  Future<List<TransaksiItem>> daftar(FilterTransaksi filter);
}
