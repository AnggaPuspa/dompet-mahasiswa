import 'package:dompet_mahasiswa/application/dompet/kelola_dompet.dart';
import 'package:dompet_mahasiswa/application/kategori/kelola_kategori.dart';
import 'package:dompet_mahasiswa/domain/entities/dompet.dart';
import 'package:dompet_mahasiswa/domain/entities/kategori.dart';
import 'package:dompet_mahasiswa/infrastructure/persistence/app_database.dart';
import 'package:dompet_mahasiswa/infrastructure/persistence/sqlite_dompet_repository.dart';
import 'package:dompet_mahasiswa/infrastructure/persistence/sqlite_kategori_repository.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

// Layar hanya mengenal kelas ini, bukan sqflite.
// Satu instance sengaja: tiap layar yang membuka berkas sendiri mudah
// melewatkan foreign key dan mengunci file di Android.
class DatabaseHelper {
  // Merakit repository dompet dan kategori. Berkas sqlite belum dibuka di sini.
  DatabaseHelper._() {
    final database = AppDatabase(pathResolver: () => pathResolver());
    _database = database;
    _dompet = KelolaDompet(SqliteDompetRepository(database));
    _kategori = KelolaKategori(SqliteKategoriRepository(database));
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
}
