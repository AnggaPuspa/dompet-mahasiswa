import 'package:dompet_mahasiswa/domain/services/kebijakan_saldo.dart';
import 'package:dompet_mahasiswa/domain/value_objects/agregat_jenis.dart';
import 'package:dompet_mahasiswa/models/dompet.dart';
import 'package:dompet_mahasiswa/models/kategori.dart';
import 'package:dompet_mahasiswa/models/transaksi.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fromMap mengembalikan field yang sama dengan toMap', () {
    final dompet = Dompet.fromMap(const Dompet(id: 1, nama: 'Tunai').toMap());
    expect(dompet.id, 1);
    expect(dompet.nama, 'Tunai');

    final kategori = Kategori.fromMap(
      Kategori(id: 2, nama: 'Gaji', jenis: 'Pemasukan').toMap(),
    );
    expect(kategori.id, 2);
    expect(kategori.nama, 'Gaji');
    expect(kategori.jenis, 'Pemasukan');

    final transaksi = Transaksi.fromMap(
      const Transaksi(
        id: 3,
        dompetId: 1,
        kategoriId: 2,
        jumlah: 50000,
        tanggal: '2026-11-20',
        catatan: 'uang saku',
      ).toMap(),
    );
    expect(transaksi.id, 3);
    expect(transaksi.dompetId, 1);
    expect(transaksi.kategoriId, 2);
    expect(transaksi.jumlah, 50000);
    expect(transaksi.tanggal, '2026-11-20');
    expect(transaksi.catatan, 'uang saku');
  });

  test('id kosong tidak ikut ke map, catatan null tetap ada', () {
    expect(const Dompet(nama: 'Tunai').toMap().containsKey('id'), isFalse);

    final map = const Transaksi(
      dompetId: 1,
      kategoriId: 2,
      jumlah: 1000,
      tanggal: '2026-11-01',
    ).toMap();
    expect(map.containsKey('id'), isFalse);
    expect(map['catatan'], isNull);

    final kembali = Transaksi.fromMap({...map, 'id': 9});
    expect(kembali.catatan, isNull);
    expect(kembali.id, 9);
  });

  test('jenis di luar Pemasukan dan Pengeluaran ditolak', () {
    expect(
      () => Kategori(nama: 'Lain', jenis: 'Transfer'),
      throwsFormatException,
    );
  });

  test('saldo mengurangi pemasukan dengan pengeluaran, bukan menjumlahkan', () {
    expect(
      hitungSaldo(const AgregatJenis(pemasukan: 50000, pengeluaran: 20000)),
      30000,
    );
    expect(hitungSaldo(const AgregatJenis(pemasukan: 0, pengeluaran: 0)), 0);
  });
}
