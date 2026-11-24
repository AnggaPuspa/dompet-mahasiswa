// Nama bulan ditulis di sini supaya hasilnya tetap bahasa Indonesia
// tanpa inisialisasi locale yang mudah terlewat di tes.
const _bulanPendek = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Agu',
  'Sep',
  'Okt',
  'Nov',
  'Des',
];

const _bulanPanjang = [
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember',
];

String formatTanggal(DateTime date) {
  return '${date.day} ${_bulanPendek[date.month - 1]} ${date.year}';
}

String formatBulanTahun(DateTime date) {
  return '${_bulanPanjang[date.month - 1]} ${date.year}';
}

String toIsoDate(DateTime date) {
  final bulan = date.month.toString().padLeft(2, '0');
  final hari = date.day.toString().padLeft(2, '0');
  return '${date.year}-$bulan-$hari';
}

String toYearMonth(DateTime date) {
  final bulan = date.month.toString().padLeft(2, '0');
  return '${date.year}-$bulan';
}

DateTime? parseIsoDate(String value) {
  final parsed = DateTime.tryParse(value);
  if (parsed == null) {
    return null;
  }
  return DateTime(parsed.year, parsed.month, parsed.day);
}
