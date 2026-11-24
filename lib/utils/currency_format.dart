// Satu pintu format rupiah. Halaman tidak merangkai "Rp" sendiri.
// Nilai negatif selalu "-Rp 1.000", bukan "Rp -1.000".
String formatRupiah(num nilai) {
  final negatif = nilai < 0;
  final teks = 'Rp ${_titikRibuan(nilai.abs().round())}';
  return negatif ? '-$teks' : teks;
}

String _titikRibuan(int nilai) {
  final sumber = nilai.toString();
  final hasil = StringBuffer();
  for (var i = 0; i < sumber.length; i++) {
    final sisa = sumber.length - i;
    if (i > 0 && sisa % 3 == 0) {
      hasil.write('.');
    }
    hasil.write(sumber[i]);
  }
  return hasil.toString();
}
