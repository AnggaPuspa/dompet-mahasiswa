import 'package:dompet_mahasiswa/theme/app_colors.dart';
import 'package:dompet_mahasiswa/theme/app_radius.dart';
import 'package:dompet_mahasiswa/utils/app_strings.dart';
import 'package:dompet_mahasiswa/utils/currency_format.dart';
import 'package:dompet_mahasiswa/widgets/summary_card.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/pump_app.dart';

void main() {
  testWidgets('summary menampilkan nominal dan ukuran frame', (tester) async {
    var taps = 0;
    await pumpApp(
      tester,
      SummaryCard(
        label: AppStrings.totalSaldo,
        amount: formatRupiah(0),
        info: AppStrings.pemasukanBulanIni,
        onTap: () => taps++,
      ),
    );

    expect(tester.getSize(find.byType(SummaryCard)), const Size(331, 106));
    final decoration = decorationOf(
      tester,
      find
          .descendant(
            of: find.byType(SummaryCard),
            matching: find.byType(DecoratedBox),
          )
          .first,
    );
    expect(decoration.color, AppColors.tintBlue);
    expect(decoration.borderRadius, AppRadius.lgAll);
    expect(find.text(AppStrings.totalSaldo), findsOneWidget);
    expect(find.text(formatRupiah(0)), findsOneWidget);

    await tester.tap(find.byType(SummaryCard));
    await tester.pump();
    expect(taps, 1);
  });
}
