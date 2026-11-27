import 'package:dompet_mahasiswa/theme/app_colors.dart';
import 'package:dompet_mahasiswa/theme/app_radius.dart';
import 'package:dompet_mahasiswa/utils/app_strings.dart';
import 'package:dompet_mahasiswa/utils/currency_format.dart';
import 'package:dompet_mahasiswa/widgets/wallet_card.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/pump_app.dart';

void main() {
  testWidgets('kartu biru berukuran frame dan mengisi progress', (
    tester,
  ) async {
    await pumpApp(tester, _card(WalletCardVariant.blue, 0.5));

    expect(
      tester.getSize(find.byType(WalletCard)),
      const Size(WalletCard.frameWidth, WalletCard.frameHeight),
    );
    final decoration = decorationOf(
      tester,
      find
          .descendant(
            of: find.byType(WalletCard),
            matching: find.byType(DecoratedBox),
          )
          .first,
    );
    expect(decoration.color, AppColors.tintBlue);
    expect(decoration.borderRadius, AppRadius.lgAll);
    expect(
      tester
          .widget<FractionallySizedBox>(find.byType(FractionallySizedBox))
          .widthFactor,
      0.5,
    );
  });

  testWidgets('varian oranye dan merah muda memakai tint masing-masing', (
    tester,
  ) async {
    await pumpApp(
      tester,
      Column(
        children: [
          _card(WalletCardVariant.orange, 0),
          _card(WalletCardVariant.pink, 1),
        ],
      ),
    );

    final boxes = tester.widgetList<DecoratedBox>(find.byType(DecoratedBox));
    final colors = boxes
        .map((box) => (box.decoration as BoxDecoration).color)
        .whereType<Color>()
        .toList();
    expect(colors, contains(AppColors.tintOrange));
    expect(colors, contains(AppColors.tintPink));
  });
}

WalletCard _card(WalletCardVariant variant, double progress) {
  return WalletCard(
    variant: variant,
    label: AppStrings.dompet,
    name: AppStrings.dompet,
    amount: formatRupiah(0),
    progress: progress,
  );
}
