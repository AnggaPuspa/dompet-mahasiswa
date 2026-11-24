import 'package:dompet_mahasiswa/main.dart';
import 'package:dompet_mahasiswa/utils/app_strings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('aplikasi terbuka tanpa crash', (tester) async {
    await tester.pumpWidget(const DompetMahasiswaApp());

    expect(find.text(AppStrings.placeholderBody), findsOneWidget);
  });
}
