import 'package:dompet_mahasiswa/domain/entities/peringkat_pengeluaran.dart';
import 'package:dompet_mahasiswa/domain/value_objects/agregat_jenis.dart';

abstract interface class LaporanRepository {
  // Menjumlahkan rupiah per jenis. dompetId dan bulan opsional; null berarti tidak disaring.
  // Pemasukan dan pengeluaran dikembalikan terpisah, belum saling dikurangi.
  Future<AgregatJenis> agregatJenis({int? dompetId, String? bulan});

  // Kategori pengeluaran terbesar pada satu bulan, paling banyak `limit` baris.
  Future<List<PeringkatPengeluaran>> topPengeluaran({
    required String bulan,
    required int limit,
  });
}
