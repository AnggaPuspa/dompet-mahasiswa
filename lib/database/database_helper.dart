import 'package:dompet_mahasiswa/application/dompet/kelola_dompet.dart';
import 'package:dompet_mahasiswa/application/kategori/kelola_kategori.dart';
import 'package:dompet_mahasiswa/application/laporan/kueri_laporan.dart';
import 'package:dompet_mahasiswa/application/transaksi/kelola_transaksi.dart';
import 'package:dompet_mahasiswa/domain/entities/dompet.dart';
import 'package:dompet_mahasiswa/domain/entities/kategori.dart';
import 'package:dompet_mahasiswa/domain/entities/transaksi.dart';
import 'package:dompet_mahasiswa/domain/entities/transaksi_item.dart';
import 'package:dompet_mahasiswa/infrastructure/persistence/app_database.dart';
import 'package:dompet_mahasiswa/infrastructure/persistence/sqlite_dompet_repository.dart';
import 'package:dompet_mahasiswa/infrastructure/persistence/sqlite_kategori_repository.dart';
import 'package:dompet_mahasiswa/infrastructure/persistence/sqlite_laporan_repository.dart';
import 'package:dompet_mahasiswa/infrastructure/persistence/sqlite_transaksi_repository.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

// Layar hanya mengenal kelas ini, bukan sqflite.
// Satu instance sengaja: tiap layar yang membuka berkas sendiri mudah
// melewatkan foreign key dan mengunci file di Android.
class DatabaseHelper {
  // Merakit repository. Berkas sqlite belum dibuka di sini.
  DatabaseHelper._() {
    final database = AppDatabase(pathResolver: () => pathResolver());
    _database = database;
    _dompet = KelolaDompet(SqliteDompetRepository(database));
    _kategori = KelolaKategori(SqliteKategoriRepository(database));
    _transaksi = KelolaTransaksi(SqliteTransaksiRepository(database));
    _laporan = KueriLaporan(SqliteLaporanRepository(database));
  }

  static DatabaseHelper? _instance;

  // Objek yang dipakai seluruh aplikasi. Dibuat pada pemanggilan pertama.
  static DatabaseHelper get instance => _instance ??= DatabaseHelper._();

  // DatabaseHelper() dan DatabaseHelper.instance mengarah ke objek yang sama.
  factory DatabaseHelper() => instance;

  // Disimpan sebagai fungsi, bukan path yang sudah dihitung.
  static Future<String> Function() pathResolver = lokasiBawaan;

  // Path berkas di folder dokumen aplikasi, supaya data tetap ada setelah aplikasi ditutup.
  static Future<String> lokasiBawaan() async {
    final directory = await getApplicationDocumentsDirectory();
    return join(directory.path, namaBerkasDatabase);
  }

  // Menutup koneksi dan membuang instance. Isi berkas tidak dihapus.
  static Future<void> reset() async {
    final current = _instance;
    _instance = null;
    if (current != null) {
      await current._database.close();
    }
  }

  late final AppDatabase _database;
  late final KelolaDompet _dompet;
  late final KelolaKategori _kategori;
  late final KelolaTransaksi _transaksi;
  late final KueriLaporan _laporan;

  // Menyimpan dompet baru. Mengembalikan id yang diisi database.
  Future<int> insertDompet(Dompet data) => _dompet.tambah(data);

  // Mengganti data dompet. Mengembalikan jumlah baris yang berubah.
  // ArgumentError bila id masih null, karena update tanpa id tidak menyentuh baris mana pun.
  Future<int> updateDompet(Dompet data) => _dompet.ubah(data);

  // Menghapus satu dompet. Mengembalikan jumlah baris terhapus.
  // Error SQLite bila dompet masih punya transaksi.
  Future<int> deleteDompet(int id) => _dompet.hapus(id);

  // Seluruh dompet, urut id menaik. List kosong bila belum ada data.
  Future<List<Dompet>> getAllDompet() => _dompet.semua();

  // Satu dompet. Null bila id tidak ditemukan.
  Future<Dompet?> getDompetById(int id) => _dompet.cari(id);

  // Pemasukan dikurangi pengeluaran pada dompet ini, menurut jenis kategori.
  // 0 bila dompet belum punya transaksi.
  Future<int> getSaldoDompet(int dompetId) => _laporan.saldoDompet(dompetId);

  // Jumlah saldo semua dompet. 0 bila belum ada transaksi sama sekali.
  Future<int> getTotalSaldoSemuaDompet() => _laporan.totalSaldoSemuaDompet();

  // Menyimpan kategori. Mengembalikan id baru.
  // Jenis selain Pemasukan atau Pengeluaran ditolak sebelum ditulis.
  Future<int> insertKategori(Kategori data) => _kategori.tambah(data);

  // Mengganti nama atau jenis kategori. Mengembalikan jumlah baris yang berubah.
  Future<int> updateKategori(Kategori data) => _kategori.ubah(data);

  // Menghapus satu kategori. Error SQLite bila masih dipakai transaksi.
  Future<int> deleteKategori(int id) => _kategori.hapus(id);

  // Seluruh kategori, urut id menaik. List kosong bila belum ada data.
  Future<List<Kategori>> getAllKategori() => _kategori.semua();

  // Satu kategori. Null bila id tidak ditemukan.
  Future<Kategori?> getKategoriById(int id) => _kategori.cari(id);

  // Kategori dengan jenis yang diminta. List kosong bila tidak ada yang cocok.
  // Jenis yang tidak dikenal melempar FormatException, bukan list kosong.
  Future<List<Kategori>> getKategoriByJenis(String jenis) {
    return _kategori.berdasarkanJenis(jenis);
  }

  // Menyimpan transaksi dan mengembalikan id baru.
  // Jumlah, kecukupan saldo, dan konfirmasi hapus tidak ditolak di sini:
  // pesan untuk aturan itu milik form. Foreign key yang gagal tetap naik
  // sebagai error SQLite, bukan ditelan.
  Future<int> insertTransaksi(Transaksi data) => _transaksi.tambah(data);

  // Mengganti isi transaksi, termasuk mengosongkan catatan.
  // Mengembalikan jumlah baris yang berubah.
  Future<int> updateTransaksi(Transaksi data) => _transaksi.ubah(data);

  // Menghapus satu transaksi. Mengembalikan jumlah baris terhapus.
  Future<int> deleteTransaksi(int id) => _transaksi.hapus(id);

  // Satu transaksi tanpa nama dompet atau kategori. Null bila id tidak ada.
  Future<Transaksi?> getTransaksiById(int id) => _transaksi.cari(id);

  // Daftar transaksi terbaru dulu, plus nama dompet, nama kategori, dan jenis.
  // bulan berbentuk yyyy-MM. Null pada bulan atau kategoriId berarti saringan itu tidak dipakai.
  // List kosong bila tidak ada yang cocok.
  Future<List<TransaksiItem>> getAllTransaksi({
    String? bulan,
    int? kategoriId,
  }) {
    return _transaksi.daftar(bulan: bulan, kategoriId: kategoriId);
  }

  // Total rupiah pemasukan pada bulan yyyy-MM. 0 bila tidak ada.
  Future<int> getTotalPemasukanBulan(String bulan) {
    return _laporan.totalPemasukanBulan(bulan);
  }

  // Total rupiah pengeluaran pada bulan yyyy-MM. 0 bila tidak ada.
  Future<int> getTotalPengeluaranBulan(String bulan) {
    return _laporan.totalPengeluaranBulan(bulan);
  }

  // Kategori pengeluaran dengan total terbesar pada bulan itu.
  // Paling banyak limit item, diurutkan total menurun. List kosong bila tidak ada pengeluaran.
  Future<List<({int kategoriId, String nama, int total})>>
  getTopKategoriPengeluaranBulan(String bulan, {int limit = 3}) {
    return _laporan.topKategoriPengeluaranBulan(bulan, limit: limit);
  }
}
