import 'package:dompet_mahasiswa/domain/repositories/laporan_repository.dart';
import 'package:dompet_mahasiswa/domain/services/kebijakan_saldo.dart';

class KueriLaporan {
  KueriLaporan(this.laporan);

  final LaporanRepository laporan;

  // Saldo satu dompet. Query hanya memisahkan jumlah per jenis;
  // pengurangan dilakukan hitungSaldo supaya rumus tidak ditulis ulang di SQL.
  Future<int> saldoDompet(int dompetId) async {
    final agregat = await laporan.agregatJenis(dompetId: dompetId);
    return hitungSaldo(agregat);
  }

  // Saldo seluruh dompet, dihitung dengan rumus yang sama seperti saldo satu dompet.
  Future<int> totalSaldoSemuaDompet() async {
    final agregat = await laporan.agregatJenis();
    return hitungSaldo(agregat);
  }

  // Jumlah pemasukan pada bulan yyyy-MM, tanpa dikurangi pengeluaran.
  Future<int> totalPemasukanBulan(String bulan) async {
    final agregat = await laporan.agregatJenis(bulan: bulan);
    return agregat.pemasukan;
  }

  // Jumlah pengeluaran pada bulan yyyy-MM.
  Future<int> totalPengeluaranBulan(String bulan) async {
    final agregat = await laporan.agregatJenis(bulan: bulan);
    return agregat.pengeluaran;
  }

  // Peringkat kategori pengeluaran, dikembalikan sebagai record (kategoriId, nama, total).
  Future<List<({int kategoriId, String nama, int total})>>
  topKategoriPengeluaranBulan(String bulan, {int limit = 3}) async {
    final daftar = await laporan.topPengeluaran(bulan: bulan, limit: limit);
    return [
      for (final item in daftar)
        (kategoriId: item.kategoriId, nama: item.nama, total: item.total),
    ];
  }
}
