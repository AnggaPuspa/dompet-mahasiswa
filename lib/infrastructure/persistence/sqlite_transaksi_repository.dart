import 'package:dompet_mahasiswa/domain/entities/transaksi.dart';
import 'package:dompet_mahasiswa/domain/entities/transaksi_item.dart';
import 'package:dompet_mahasiswa/domain/queries/filter_transaksi.dart';
import 'package:dompet_mahasiswa/domain/repositories/transaksi_repository.dart';
import 'package:dompet_mahasiswa/infrastructure/persistence/app_database.dart';
import 'package:dompet_mahasiswa/infrastructure/persistence/sql_bantuan.dart';

class SqliteTransaksiRepository implements TransaksiRepository {
  SqliteTransaksiRepository(this._database);

  final AppDatabase _database;

  // Menulis satu transaksi. Mengembalikan id baru. Gagal bila dompet atau kategori tidak ada.
  @override
  Future<int> tambah(Transaksi data) async {
    final db = await _database.database;
    return db.insert(tabelTransaksi, data.toMap());
  }

  // Mengganti baris transaksi dengan id yang sama.
  @override
  Future<int> ubah(Transaksi data) async {
    final db = await _database.database;
    final id = wajibId(data.id, 'transaksi');
    return db.update(
      tabelTransaksi,
      data.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Menghapus satu baris transaksi.
  @override
  Future<int> hapus(int id) async {
    final db = await _database.database;
    return db.delete(tabelTransaksi, where: 'id = ?', whereArgs: [id]);
  }

  // Satu baris tabel transaksi, tanpa join nama.
  @override
  Future<Transaksi?> cari(int id) async {
    final db = await _database.database;
    final rows = await db.query(
      tabelTransaksi,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) {
      return null;
    }
    return Transaksi.fromMap(rows.first);
  }

  // Menggabungkan transaksi dengan nama dompet dan kategori, terbaru di atas.
  @override
  Future<List<TransaksiItem>> daftar(FilterTransaksi filter) async {
    final db = await _database.database;
    // Klausa yang tidak dipakai tidak ikut ke SQL.
    // Bentuk `WHERE (? IS NULL OR ...)` dihindari: beberapa driver menolak argumen null.
    final conditions = <String>[];
    final args = <Object?>[];
    final bulan = filter.bulan;
    if (bulan != null) {
      // Bukan kolom DATE. Tujuh karakter pertama teks yyyy-MM-dd adalah bulannya.
      conditions.add('substr(t.tanggal, 1, 7) = ?');
      args.add(bulan);
    }
    final kategoriId = filter.kategoriId;
    if (kategoriId != null) {
      conditions.add('t.kategori_id = ?');
      args.add(kategoriId);
    }
    final where = conditions.isEmpty ? '' : 'WHERE ${conditions.join(' AND ')}';
    final rows = await db.rawQuery('''
      SELECT
        t.id AS id,
        t.dompet_id AS dompet_id,
        t.kategori_id AS kategori_id,
        t.jumlah AS jumlah,
        t.tanggal AS tanggal,
        t.catatan AS catatan,
        d.nama AS nama_dompet,
        k.nama AS nama_kategori,
        k.jenis AS jenis_kategori
      FROM $tabelTransaksi t
      INNER JOIN $tabelDompet d ON d.id = t.dompet_id
      INNER JOIN $tabelKategori k ON k.id = t.kategori_id
      $where
      -- Tidak ada jam pada tanggal. Id lebih besar berarti disimpan lebih belakangan.
      ORDER BY t.tanggal DESC, t.id DESC
      ''', args);
    return [for (final row in rows) TransaksiItem.fromMap(row)];
  }

  // True bila COUNT transaksi untuk dompet ini lebih dari nol.
  @override
  Future<bool> adaUntukDompet(int dompetId) {
    return _ada('dompet_id', dompetId);
  }

  // True bila COUNT transaksi untuk kategori ini lebih dari nol.
  @override
  Future<bool> adaUntukKategori(int kategoriId) {
    return _ada('kategori_id', kategoriId);
  }

  // Menghitung baris transaksi pada satu kolom id. False bila hasilnya nol, termasuk id yang tidak ada.
  Future<bool> _ada(String kolom, int id) async {
    final db = await _database.database;
    final rows = await db.rawQuery(
      'SELECT COUNT(*) AS jumlah FROM $tabelTransaksi WHERE $kolom = ?',
      [id],
    );
    return bacaInt(rows.first['jumlah']) > 0;
  }
}
