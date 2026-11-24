import 'package:dompet_mahasiswa/domain/entities/peringkat_pengeluaran.dart';
import 'package:dompet_mahasiswa/domain/repositories/laporan_repository.dart';
import 'package:dompet_mahasiswa/domain/value_objects/agregat_jenis.dart';
import 'package:dompet_mahasiswa/domain/value_objects/jenis_kategori.dart';
import 'package:dompet_mahasiswa/infrastructure/persistence/app_database.dart';
import 'package:dompet_mahasiswa/infrastructure/persistence/sql_bantuan.dart';

class SqliteLaporanRepository implements LaporanRepository {
  SqliteLaporanRepository(this._database);

  final AppDatabase _database;

  // Menjumlahkan jumlah per jenis kategori. Tidak mengurangi; pemanggil yang menghitung saldo.
  @override
  Future<AgregatJenis> agregatJenis({int? dompetId, String? bulan}) async {
    final db = await _database.database;
    // Argumen CASE harus di depan, sebelum argumen filter: urutannya
    // mengikuti tanda ? di SQL, bukan urutan if di bawah.
    // Arah uang di-join dari kategori. Jangan kurangi di query ini;
    // pengurangan ada di hitungSaldo supaya laporan lain memakai agregat yang sama.
    final conditions = <String>[];
    final args = <Object?>[
      JenisKategori.pemasukan.value,
      JenisKategori.pengeluaran.value,
    ];
    if (dompetId != null) {
      conditions.add('t.dompet_id = ?');
      args.add(dompetId);
    }
    if (bulan != null) {
      // tanggal disimpan sebagai teks yyyy-MM-dd, bukan tipe DATE.
      // substr 7 karakter mengambil yyyy-MM tanpa fungsi tanggal SQLite,
      // yang formatnya tidak sama di tiap build.
      conditions.add('substr(t.tanggal, 1, 7) = ?');
      args.add(bulan);
    }
    final where = conditions.isEmpty ? '' : 'WHERE ${conditions.join(' AND ')}';
    final rows = await db.rawQuery('''
      SELECT
        -- SUM tanpa baris adalah NULL. COALESCE membuat dompet kosong tetap 0,
        -- bukan nilai yang harus ditangkap layar sebagai error.
        COALESCE(SUM(CASE WHEN k.jenis = ? THEN t.jumlah ELSE 0 END), 0) AS pemasukan,
        COALESCE(SUM(CASE WHEN k.jenis = ? THEN t.jumlah ELSE 0 END), 0) AS pengeluaran
      FROM $tabelTransaksi t
      INNER JOIN $tabelKategori k ON k.id = t.kategori_id
      $where
      ''', args);
    if (rows.isEmpty) {
      return AgregatJenis.kosong;
    }
    final row = rows.first;
    return AgregatJenis(
      pemasukan: bacaInt(row['pemasukan']),
      pengeluaran: bacaInt(row['pengeluaran']),
    );
  }

  // Mengelompokkan pengeluaran per kategori, total terbesar dulu, dipotong sesuai limit.
  @override
  Future<List<PeringkatPengeluaran>> topPengeluaran({
    required String bulan,
    required int limit,
  }) async {
    final db = await _database.database;
    final rows = await db.rawQuery(
      '''
      SELECT
        k.id AS kategori_id,
        k.nama AS nama,
        COALESCE(SUM(t.jumlah), 0) AS total
      FROM $tabelTransaksi t
      INNER JOIN $tabelKategori k ON k.id = t.kategori_id
      WHERE k.jenis = ? AND substr(t.tanggal, 1, 7) = ?
      GROUP BY k.id, k.nama
      -- Total yang sama tidak boleh berganti posisi tiap query.
      ORDER BY total DESC, k.nama ASC
      LIMIT ?
      ''',
      [JenisKategori.pengeluaran.value, bulan, limit],
    );
    return [
      for (final row in rows)
        PeringkatPengeluaran(
          kategoriId: bacaInt(row['kategori_id']),
          nama: row['nama'] as String,
          total: bacaInt(row['total']),
        ),
    ];
  }
}
