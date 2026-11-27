import 'package:dompet_mahasiswa/theme/app_colors.dart';
import 'package:dompet_mahasiswa/theme/app_radius.dart';
import 'package:dompet_mahasiswa/utils/app_strings.dart';
import 'package:dompet_mahasiswa/widgets/hero_card.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/pump_app.dart';

void main() {
  testWidgets('hero menampilkan teks, ukuran frame, dan tombol', (
    tester,
  ) async {
    var taps = 0;
    await pumpApp(
      tester,
      HeroCard(
        caption: AppStrings.pengeluaranBulanIni,
        line1: AppStrings.pemasukan,
        line2: AppStrings.pengeluaran,
        buttonLabel: AppStrings.lihatRiwayat,
        percent: 0,
        onButtonPressed: () => taps++,
      ),
    );

    expect(tester.getSize(find.byType(HeroCard)), const Size(331, 146));
    final decoration = decorationOf(
      tester,
      find
          .descendant(
            of: find.byType(HeroCard),
            matching: find.byType(DecoratedBox),
          )
          .first,
    );
    expect(decoration.color, AppColors.primary);
    expect(decoration.borderRadius, AppRadius.xlAll);
    expect(find.text(AppStrings.lihatRiwayat), findsOneWidget);
    expect(find.text('0%'), findsOneWidget);

    await tester.tap(find.text(AppStrings.lihatRiwayat));
    await tester.pump();
    expect(taps, 1);
  });
}
