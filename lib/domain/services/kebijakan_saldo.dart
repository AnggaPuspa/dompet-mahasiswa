import 'package:dompet_mahasiswa/domain/value_objects/agregat_jenis.dart';

// Jangan kurangi berdasarkan tanda jumlah. Pemasukan dan pengeluaran
// sama-sama disimpan positif; yang membedakan arah adalah jenis kategori.
// Pengurangan ada di sini, bukan di SQL, supaya rumus saldo tidak tersebar
// di tiap query laporan.
int hitungSaldo(AgregatJenis agregat) {
  return agregat.pemasukan - agregat.pengeluaran;
}
