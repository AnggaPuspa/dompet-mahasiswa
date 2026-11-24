class FilterTransaksi {
  const FilterTransaksi({this.bulan, this.kategoriId});

  // Null berarti saringan ini tidak ikut ke SQL.
  // yyyy-MM, bukan tanggal lengkap: pemanggil menyaring per bulan.
  final String? bulan;
  final int? kategoriId;
}
