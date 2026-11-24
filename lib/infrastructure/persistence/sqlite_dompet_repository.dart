import 'package:dompet_mahasiswa/domain/entities/dompet.dart';
import 'package:dompet_mahasiswa/domain/repositories/dompet_repository.dart';
import 'package:dompet_mahasiswa/infrastructure/persistence/app_database.dart';
import 'package:dompet_mahasiswa/infrastructure/persistence/sql_bantuan.dart';

class SqliteDompetRepository implements DompetRepository {
  SqliteDompetRepository(this._database);

  final AppDatabase _database;

  // Menulis satu baris dompet. Mengembalikan id AUTOINCREMENT.
  @override
  Future<int> tambah(Dompet data) async {
    final db = await _database.database;
    return db.insert(tabelDompet, data.toMap());
  }

  // Mengganti baris dengan id yang sama. Mengembalikan jumlah baris yang kena.
  @override
  Future<int> ubah(Dompet data) async {
    final db = await _database.database;
    final id = wajibId(data.id, 'dompet');
    return db.update(
      tabelDompet,
      data.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Menghapus baris dompet. Foreign key yang masih merujuk baris ini membuat panggilan gagal.
  @override
  Future<int> hapus(int id) async {
    final db = await _database.database;
    return db.delete(tabelDompet, where: 'id = ?', whereArgs: [id]);
  }

  // Membaca seluruh tabel, urut id menaik.
  @override
  Future<List<Dompet>> semua() async {
    final db = await _database.database;
    final rows = await db.query(tabelDompet, orderBy: 'id ASC');
    return rows.map(Dompet.fromMap).toList();
  }

  // Membaca satu baris. Null bila query tidak mengembalikan apa pun.
  @override
  Future<Dompet?> cari(int id) async {
    final db = await _database.database;
    final rows = await db.query(
      tabelDompet,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) {
      return null;
    }
    return Dompet.fromMap(rows.first);
  }
}
