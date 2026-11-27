// sqflite_common sudah ada lewat sqflite. Dependensi langsung tidak ditambah.
// ignore: depend_on_referenced_packages
import 'package:sqflite_common/utils/utils.dart';

/// Mematikan timer peringatan kunci database.
///
/// sqflite menjadwalkan timer 10 detik di zona FakeAsync. Kalau kuncinya
/// baru lepas lewat [WidgetTester.runAsync], timer itu tetap menggantung
/// dan tes widget gagal.
void silenceDatabaseLockWarning() {
  // ignore: deprecated_member_use
  lockWarningDuration = null;
}
