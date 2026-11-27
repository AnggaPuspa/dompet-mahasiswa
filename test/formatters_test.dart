import 'package:dompet_mahasiswa/utils/currency_format.dart';
import 'package:dompet_mahasiswa/utils/date_format.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('formatRupiah memakai titik ribuan', () {
    expect(formatRupiah(10000), 'Rp 10.000');
    expect(formatRupiah(0), 'Rp 0');
    expect(formatRupiah(-1000), '-Rp 1.000');
  });

  test('tanggal mengikuti contoh Indonesia dan iso', () {
    final date = DateTime(2026, 11, 23);
    expect(formatTanggal(date), '23 Nov 2026');
    expect(formatBulanTahun(date), 'November 2026');
    expect(formatBulanTahunPendek(date), 'Nov 2026');
    expect(toIsoDate(date), '2026-11-23');
    expect(toYearMonth(date), '2026-11');
    expect(parseIsoDate('2026-11-23'), date);
    expect(parseIsoDate('bukan-tanggal'), isNull);
  });
}
