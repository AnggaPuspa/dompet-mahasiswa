class AgregatJenis {
  const AgregatJenis({required this.pemasukan, required this.pengeluaran});

  final int pemasukan;
  final int pengeluaran;

  static const kosong = AgregatJenis(pemasukan: 0, pengeluaran: 0);
}
