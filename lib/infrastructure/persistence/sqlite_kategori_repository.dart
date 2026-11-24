import 'package:dompet_mahasiswa/domain/entities/kategori.dart';
import 'package:dompet_mahasiswa/domain/repositories/kategori_repository.dart';
import 'package:dompet_mahasiswa/domain/value_objects/jenis_kategori.dart';
import 'package:dompet_mahasiswa/infrastructure/persistence/app_database.dart';
import 'package:dompet_mahasiswa/infrastructure/persistence/sql_bantuan.dart';

class SqliteKategoriRepository implements KategoriRepository {
  SqliteKategoriRepository(this._database);

  final AppDatabase _database;

  // Menulis satu baris kategori. Mengembalikan id baru.
  @override
  Future<int> tambah(Kategori data) async {
    final db = await _database.database;
    return db.insert(tabelKategori, data.toMap());
  }

  // Mengganti baris kategori dengan id yang sama.
  @override
  Future<int> ubah(Kategori data) async {
    final db = await _database.database;
    final id = wajibId(data.id, 'kategori');
    return db.update(
      tabelKategori,
      data.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Menghapus baris kategori. Gagal bila transaksi masih merujuknya.
  @override
  Future<int> hapus(int id) async {
    final db = await _database.database;
    return db.delete(tabelKategori, where: 'id = ?', whereArgs: [id]);
  }

  // Membaca seluruh tabel kategori, urut id menaik.
  @override
  Future<List<Kategori>> semua() async {
    final db = await _database.database;
    final rows = await db.query(tabelKategori, orderBy: 'id ASC');
    return rows.map(Kategori.fromMap).toList();
  }

  // Satu baris kategori, atau null.
  @override
  Future<Kategori?> cari(int id) async {
    final db = await _database.database;
    final rows = await db.query(
      tabelKategori,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) {
      return null;
    }
    return Kategori.fromMap(rows.first);
  }

  // Memilih baris yang kolom jenis-nya sama dengan nilai enum.
  @override
  Future<List<Kategori>> berdasarkanJenis(JenisKategori jenis) async {
    final db = await _database.database;
    final rows = await db.query(
      tabelKategori,
      where: 'jenis = ?',
      whereArgs: [jenis.value],
      orderBy: 'id ASC',
    );
    return rows.map(Kategori.fromMap).toList();
  }
}
