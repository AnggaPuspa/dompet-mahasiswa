import 'package:sqflite/sqflite.dart';

const tabelDompet = 'dompet';
const tabelKategori = 'kategori';
const tabelTransaksi = 'transaksi';

const namaBerkasDatabase = 'dompet_mahasiswa.db';

class AppDatabase {
  AppDatabase({required this.pathResolver});

  final Future<String> Function() pathResolver;
  Future<Database>? _opening;

  // Koneksi yang sudah dibuka, atau membuka berkas bila ini pemanggilan pertama.
  Future<Database> get database async {
    final opening = _opening ??= _open();
    final Database db;
    try {
      db = await opening;
    } catch (_) {
      if (identical(_opening, opening)) _opening = null;
      rethrow;
    }
    // Pragma ini per koneksi dan default-nya mati.
    // Diulang di sini, bukan hanya saat create: hot restart bisa memakai
    // koneksi baru yang belum pernah melewati onConfigure.
    await db.execute('PRAGMA foreign_keys = ON');
    return db;
  }

  // Menutup berkas sqlite. Pemanggilan database berikutnya membuka koneksi baru.
  Future<void> close() async {
    final opening = _opening;
    // Dikosongkan dulu. Kalau koneksi ditutup belakangan, pemanggil lain
    // bisa mengambil objek yang sedang ditutup.
    _opening = null;
    if (opening == null) {
      return;
    }
    final db = await opening;
    await db.close();
  }

  // Membuat atau membuka berkas. Tabel hanya dibuat bila berkas belum ada.
  Future<Database> _open() {
    return pathResolver().then((path) {
      return openDatabase(
        path,
        version: 1,
        onConfigure: (db) async {
          // Jangan pindahkan pragma ini ke onCreate.
          // onCreate berjalan di dalam transaksi, dan SQLite mengabaikan
          // PRAGMA foreign_keys selama transaksi masih terbuka.
          await db.execute('PRAGMA foreign_keys = ON');
        },
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE $tabelDompet (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              nama TEXT NOT NULL
            )
          ''');
          await db.execute('''
            CREATE TABLE $tabelKategori (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              nama TEXT NOT NULL,
              jenis TEXT NOT NULL
            )
          ''');
          await db.execute('''
            CREATE TABLE $tabelTransaksi (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              dompet_id INTEGER NOT NULL,
              kategori_id INTEGER NOT NULL,
              jumlah INTEGER NOT NULL,
              tanggal TEXT NOT NULL,
              catatan TEXT,
              -- Tanpa ON DELETE CASCADE. Hapus dompet/kategori yang masih
              -- punya transaksi harus gagal, bukan menghapus riwayat diam-diam.
              FOREIGN KEY(dompet_id) REFERENCES $tabelDompet(id),
              FOREIGN KEY(kategori_id) REFERENCES $tabelKategori(id)
            )
          ''');
        },
      );
    });
  }
}
