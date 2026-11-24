import 'package:dompet_mahasiswa/application/dompet/kelola_dompet.dart';
import 'package:dompet_mahasiswa/domain/entities/dompet.dart';
import 'package:dompet_mahasiswa/infrastructure/persistence/app_database.dart';
import 'package:dompet_mahasiswa/infrastructure/persistence/sqlite_dompet_repository.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

// Layar hanya mengenal kelas ini, bukan sqflite.
// Satu instance sengaja: tiap layar yang membuka berkas sendiri mudah
// melewatkan foreign key dan mengunci file di Android.
class DatabaseHelper {
  // Merakit repository dompet. Berkas sqlite belum dibuka di sini.
  DatabaseHelper._() {
    final database = AppDatabase(pathResolver: () => pathResolver());
    _database = database;
    _dompet = KelolaDompet(SqliteDompetRepository(database));
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
}
