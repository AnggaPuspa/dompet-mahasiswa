import 'dart:io';

import 'package:dompet_mahasiswa/database/database_helper.dart';
import 'package:dompet_mahasiswa/models/dompet.dart';
import 'package:dompet_mahasiswa/models/kategori.dart';
import 'package:dompet_mahasiswa/models/transaksi.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late Directory tempDir;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('dompet_mahasiswa_');
    DatabaseHelper.pathResolver = () async =>
        join(tempDir.path, 'dompet_mahasiswa.db');
    await DatabaseHelper.reset();
  });

  tearDown(() async {
    await DatabaseHelper.reset();
    DatabaseHelper.pathResolver = DatabaseHelper.lokasiBawaan;
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  DatabaseHelper db() => DatabaseHelper.instance;

  test('dataset kosong mengembalikan list kosong, nol, atau null', () async {
    expect(await db().getAllDompet(), isEmpty);
    expect(await db().getAllKategori(), isEmpty);
    expect(await db().getAllTransaksi(), isEmpty);
    expect(await db().getDompetById(1), isNull);
    expect(await db().getKategoriById(1), isNull);
    expect(await db().getTransaksiById(1), isNull);
    expect(await db().getKategoriByJenis('Pemasukan'), isEmpty);
    expect(await db().getSaldoDompet(1), 0);
    expect(await db().getTotalSaldoSemuaDompet(), 0);
    expect(await db().getTotalPemasukanBulan('2026-11'), 0);
    expect(await db().getTotalPengeluaranBulan('2026-11'), 0);
    expect(await db().getTopKategoriPengeluaranBulan('2026-11'), isEmpty);
    expect(await db().isDompetUsedInTransaksi(1), isFalse);
    expect(await db().isKategoriUsedInTransaksi(1), isFalse);
  });

  test('pemasukan 50000 dan pengeluaran 20000 bersaldo 30000', () async {
    final dompetId = await db().insertDompet(const Dompet(nama: 'Tunai'));
    final gajiId = await db().insertKategori(
      Kategori(nama: 'Gaji', jenis: 'Pemasukan'),
    );
    final makanId = await db().insertKategori(
      Kategori(nama: 'Makan', jenis: 'Pengeluaran'),
    );
    await db().insertTransaksi(
      Transaksi(
        dompetId: dompetId,
        kategoriId: gajiId,
        jumlah: 50000,
        tanggal: '2026-11-20',
      ),
    );
    await db().insertTransaksi(
      Transaksi(
        dompetId: dompetId,
        kategoriId: makanId,
        jumlah: 20000,
        tanggal: '2026-11-02',
      ),
    );

    expect(await db().getSaldoDompet(dompetId), 30000);
    expect(await db().getTotalSaldoSemuaDompet(), 30000);
    expect(await db().getTotalPemasukanBulan('2026-11'), 50000);
    expect(await db().getTotalPengeluaranBulan('2026-11'), 20000);
    expect(await db().getTotalPemasukanBulan('2026-01'), 0);
    expect(await db().isDompetUsedInTransaksi(dompetId), isTrue);
    expect(await db().isKategoriUsedInTransaksi(gajiId), isTrue);
    expect(await db().isKategoriUsedInTransaksi(makanId), isTrue);

    final top = await db().getTopKategoriPengeluaranBulan('2026-11');
    expect(top, hasLength(1));
    expect(top.single.kategoriId, makanId);
    expect(top.single.nama, 'Makan');
    expect(top.single.total, 20000);
  });

  test('saldo dompet lain tidak tercampur, total menjumlahkan semua', () async {
    final tunaiId = await db().insertDompet(const Dompet(nama: 'Tunai'));
    final bankId = await db().insertDompet(const Dompet(nama: 'Bank'));
    final gajiId = await db().insertKategori(
      Kategori(nama: 'Gaji', jenis: 'Pemasukan'),
    );
    final makanId = await db().insertKategori(
      Kategori(nama: 'Makan', jenis: 'Pengeluaran'),
    );
    await db().insertTransaksi(
      Transaksi(
        dompetId: tunaiId,
        kategoriId: gajiId,
        jumlah: 50000,
        tanggal: '2026-11-01',
      ),
    );
    await db().insertTransaksi(
      Transaksi(
        dompetId: tunaiId,
        kategoriId: makanId,
        jumlah: 20000,
        tanggal: '2026-11-02',
      ),
    );
    await db().insertTransaksi(
      Transaksi(
        dompetId: bankId,
        kategoriId: gajiId,
        jumlah: 10000,
        tanggal: '2026-11-03',
      ),
    );

    expect(await db().getSaldoDompet(tunaiId), 30000);
    expect(await db().getSaldoDompet(bankId), 10000);
    expect(await db().getTotalSaldoSemuaDompet(), 40000);
  });

  test('mengubah jenis kategori mengubah arah saldo', () async {
    final dompetId = await db().insertDompet(const Dompet(nama: 'Tunai'));
    final gajiId = await db().insertKategori(
      Kategori(nama: 'Gaji', jenis: 'Pemasukan'),
    );
    final makanId = await db().insertKategori(
      Kategori(nama: 'Makan', jenis: 'Pengeluaran'),
    );
    await db().insertTransaksi(
      Transaksi(
        dompetId: dompetId,
        kategoriId: gajiId,
        jumlah: 50000,
        tanggal: '2026-11-01',
      ),
    );
    await db().insertTransaksi(
      Transaksi(
        dompetId: dompetId,
        kategoriId: makanId,
        jumlah: 20000,
        tanggal: '2026-11-02',
      ),
    );

    await db().updateKategori(
      Kategori(id: gajiId, nama: 'Gaji', jenis: 'Pengeluaran'),
    );

    expect(await db().getSaldoDompet(dompetId), -70000);
  });

  test('crud dompet dan kategori', () async {
    final dompetId = await db().insertDompet(const Dompet(nama: 'Tunai'));
    await db().updateDompet(Dompet(id: dompetId, nama: 'Cash'));
    expect((await db().getDompetById(dompetId))?.nama, 'Cash');

    final gajiId = await db().insertKategori(
      Kategori(nama: 'Gaji', jenis: 'Pemasukan'),
    );
    final makanId = await db().insertKategori(
      Kategori(nama: 'Makan', jenis: 'Pengeluaran'),
    );
    expect(await db().getKategoriByJenis('Pemasukan'), hasLength(1));
    expect((await db().getKategoriByJenis('Pemasukan')).single.nama, 'Gaji');
    expect((await db().getKategoriByJenis('Pengeluaran')).single.id, makanId);

    await db().updateKategori(
      Kategori(id: gajiId, nama: 'Uang saku', jenis: 'Pemasukan'),
    );
    expect((await db().getKategoriById(gajiId))?.nama, 'Uang saku');

    expect(await db().deleteKategori(makanId), 1);
    expect(await db().getAllKategori(), hasLength(1));
    expect(await db().deleteDompet(dompetId), 1);
    expect(await db().getAllDompet(), isEmpty);
  });

  test('daftar transaksi terurut, terfilter, dan membawa nama', () async {
    final dompetId = await db().insertDompet(const Dompet(nama: 'Tunai'));
    final gajiId = await db().insertKategori(
      Kategori(nama: 'Gaji', jenis: 'Pemasukan'),
    );
    final makanId = await db().insertKategori(
      Kategori(nama: 'Makan', jenis: 'Pengeluaran'),
    );
    final transportId = await db().insertKategori(
      Kategori(nama: 'Transport', jenis: 'Pengeluaran'),
    );

    final lamaId = await db().insertTransaksi(
      Transaksi(
        dompetId: dompetId,
        kategoriId: gajiId,
        jumlah: 50000,
        tanggal: '2026-11-01',
      ),
    );
    final makanTransaksiId = await db().insertTransaksi(
      Transaksi(
        dompetId: dompetId,
        kategoriId: makanId,
        jumlah: 20000,
        tanggal: '2026-11-03',
        catatan: 'warung',
      ),
    );
    final sehariId = await db().insertTransaksi(
      Transaksi(
        dompetId: dompetId,
        kategoriId: transportId,
        jumlah: 15000,
        tanggal: '2026-11-03',
      ),
    );
    final oktoberId = await db().insertTransaksi(
      Transaksi(
        dompetId: dompetId,
        kategoriId: transportId,
        jumlah: 7000,
        tanggal: '2026-10-15',
      ),
    );

    final semua = await db().getAllTransaksi();
    expect(semua.map((item) => item.id).toList(), [
      sehariId,
      makanTransaksiId,
      lamaId,
      oktoberId,
    ]);
    expect(semua.first.tanggal, '2026-11-03');
    expect(semua.first.namaDompet, 'Tunai');
    expect(semua.first.namaKategori, 'Transport');
    expect(semua.first.jenisKategori, 'Pengeluaran');

    final november = await db().getAllTransaksi(bulan: '2026-11');
    expect(november, hasLength(3));
    final makanNovember = await db().getAllTransaksi(
      bulan: '2026-11',
      kategoriId: makanId,
    );
    expect(makanNovember, hasLength(1));
    expect(makanNovember.single.catatan, 'warung');
    expect(makanNovember.single.jumlah, 20000);

    final idMakan = makanNovember.single.id!;
    await db().updateTransaksi(
      Transaksi(
        id: idMakan,
        dompetId: dompetId,
        kategoriId: makanId,
        jumlah: 20000,
        tanggal: '2026-11-03',
        catatan: 'kantin',
      ),
    );
    expect((await db().getTransaksiById(idMakan))?.catatan, 'kantin');

    expect(await db().deleteTransaksi(idMakan), 1);
    expect(await db().getAllTransaksi(kategoriId: makanId), isEmpty);

    final top = await db().getTopKategoriPengeluaranBulan('2026-11');
    expect(top.map((item) => item.nama).toList(), ['Transport']);
    expect(top.single.total, 15000);
    expect(await db().getTopKategoriPengeluaranBulan('2026-01'), isEmpty);
  });

  test(
    'foreign key menolak transaksi tanpa dompet, lalu boleh dihapus',
    () async {
      final dompetId = await db().insertDompet(const Dompet(nama: 'Tunai'));
      final gajiId = await db().insertKategori(
        Kategori(nama: 'Gaji', jenis: 'Pemasukan'),
      );

      expect(
        () => db().insertTransaksi(
          const Transaksi(
            dompetId: 999,
            kategoriId: 1,
            jumlah: 1000,
            tanggal: '2026-11-01',
          ),
        ),
        throwsA(isA<DatabaseException>()),
      );

      final transaksiId = await db().insertTransaksi(
        Transaksi(
          dompetId: dompetId,
          kategoriId: gajiId,
          jumlah: 1000,
          tanggal: '2026-11-01',
        ),
      );
      expect(
        () => db().deleteDompet(dompetId),
        throwsA(isA<DatabaseException>()),
      );

      await db().deleteTransaksi(transaksiId);
      expect(await db().isDompetUsedInTransaksi(dompetId), isFalse);
      expect(await db().isKategoriUsedInTransaksi(gajiId), isFalse);
      expect(await db().deleteDompet(dompetId), 1);
    },
  );

  test('data tetap ada setelah koneksi ditutup', () async {
    final dompetId = await db().insertDompet(const Dompet(nama: 'Tunai'));
    final gajiId = await db().insertKategori(
      Kategori(nama: 'Gaji', jenis: 'Pemasukan'),
    );
    final makanId = await db().insertKategori(
      Kategori(nama: 'Makan', jenis: 'Pengeluaran'),
    );
    await db().insertTransaksi(
      Transaksi(
        dompetId: dompetId,
        kategoriId: gajiId,
        jumlah: 50000,
        tanggal: '2026-11-20',
      ),
    );
    await db().insertTransaksi(
      Transaksi(
        dompetId: dompetId,
        kategoriId: makanId,
        jumlah: 20000,
        tanggal: '2026-11-02',
      ),
    );

    await DatabaseHelper.reset();

    expect(await db().getAllDompet(), hasLength(1));
    expect(await db().getSaldoDompet(dompetId), 30000);
    expect(await db().getTotalSaldoSemuaDompet(), 30000);
  });
}
