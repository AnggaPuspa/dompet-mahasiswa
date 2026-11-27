import 'package:dompet_mahasiswa/theme/app_colors.dart';
import 'package:dompet_mahasiswa/utils/app_strings.dart';
import 'package:dompet_mahasiswa/widgets/periode_chips.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/pump_app.dart';

void main() {
  final items = [
    PeriodeChipData(
      id: '2026-09',
      top: '2026',
      main: 'Sep',
      bottom: AppStrings.jumlahTransaksi(9),
    ),
    PeriodeChipData(
      id: '2026-11',
      top: '2026',
      main: 'Nov',
      bottom: AppStrings.jumlahTransaksi(6),
    ),
  ];

  testWidgets('chip bulanan terpilih berlatar primary dan bisa ditekan', (
    tester,
  ) async {
    String? selected = '2026-11';
    await pumpApp(
      tester,
      PeriodeChips(
        periode: Periode.bulanan,
        items: items,
        selectedId: selected,
        onSelected: (id) => selected = id,
      ),
    );

    expect(find.text('Nov'), findsOneWidget);
    expect(find.text(AppStrings.jumlahTransaksi(6)), findsOneWidget);
    final selectedCard = find.ancestor(
      of: find.text('Nov'),
      matching: find.byType(DecoratedBox),
    );
    expect(decorationOf(tester, selectedCard.first).color, AppColors.primary);
    expect(
      tester.getSize(selectedCard.first),
      const Size(PeriodeChips.monthWidth, PeriodeChips.frameHeight),
    );

    await tester.tap(find.text('Sep'));
    await tester.pump();
    expect(selected, '2026-09');
  });

  testWidgets('mode mingguan memakai kartu persegi', (tester) async {
    await pumpApp(
      tester,
      PeriodeChips(
        periode: Periode.mingguan,
        selectedId: 'w1',
        items: [
          PeriodeChipData(
            id: 'w1',
            top: AppStrings.periodeMingguan,
            main: '2-8',
            bottom: AppStrings.jumlahTransaksi(1),
          ),
        ],
      ),
    );

    expect(
      tester.getSize(find.byType(DecoratedBox).first),
      const Size(PeriodeChips.squareExtent, PeriodeChips.frameHeight),
    );
  });
}
