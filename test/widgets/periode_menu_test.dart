import 'package:dompet_mahasiswa/theme/app_colors.dart';
import 'package:dompet_mahasiswa/utils/app_strings.dart';
import 'package:dompet_mahasiswa/widgets/periode_chips.dart';
import 'package:dompet_mahasiswa/widgets/periode_menu.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/pump_app.dart';

void main() {
  testWidgets('menu menampilkan tiga periode dan centang pada yang dipilih', (
    tester,
  ) async {
    var selected = Periode.bulanan;
    await pumpApp(
      tester,
      PeriodeMenu(selected: selected, onSelected: (value) => selected = value),
    );

    expect(find.text(AppStrings.periodeMingguan), findsOneWidget);
    expect(find.text(AppStrings.periodeBulanan), findsOneWidget);
    expect(find.text(AppStrings.periodeTahunan), findsOneWidget);
    expect(find.byIcon(Icons.check), findsOneWidget);
    expect(
      tester.getSize(find.byType(PeriodeMenu)).width,
      PeriodeMenu.frameWidth,
    );

    final selectedRow = find.ancestor(
      of: find.text(AppStrings.periodeBulanan),
      matching: find.byType(Material),
    );
    expect(
      tester.widget<Material>(selectedRow.first).color,
      AppColors.tintLilac,
    );

    await tester.tap(find.text(AppStrings.periodeTahunan));
    await tester.pump();
    expect(selected, Periode.tahunan);
  });
}
