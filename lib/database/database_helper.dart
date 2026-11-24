import 'package:dompet_mahasiswa/infrastructure/persistence/app_database.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

// Layar hanya mengenal kelas ini, bukan sqflite.
// Satu instance sengaja: tiap layar yang membuka berkas sendiri mudah
// melewatkan foreign key dan mengunci file di Android.
class DatabaseHelper {
  // Berkas sqlite belum dibuka di sini. Tabel dibuat pada koneksi pertama.
  DatabaseHelper._() {
    _database = AppDatabase(pathResolver: () => pathResolver());
  }

  static DatabaseHelper? _instance;

  // Objek yang dipakai seluruh aplikasi. Dibuat pada pemanggilan pertama.
  static DatabaseHelper get instance => _instance ??= DatabaseHelper._();

  // DatabaseHelper() dan DatabaseHelper.instance mengarah ke objek yang sama.
  factory DatabaseHelper() => instance;

  // Disimpan sebagai fungsi, bukan path yang sudah dihitung.
  // Path dibaca saat koneksi dibuka, jadi penggantian (misalnya folder tes)
  // tetap kena pada pembukaan berikutnya, bukan terkunci di konstruktor.
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
}
