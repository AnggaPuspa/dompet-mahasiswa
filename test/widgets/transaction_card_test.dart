import 'package:dompet_mahasiswa/domain/value_objects/jenis_kategori.dart';
import 'package:dompet_mahasiswa/theme/app_colors.dart';
import 'package:dompet_mahasiswa/theme/app_radius.dart';
import 'package:dompet_mahasiswa/utils/app_strings.dart';
import 'package:dompet_mahasiswa/utils/currency_format.dart';
import 'package:dompet_mahasiswa/widgets/transaction_card.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/pump_app.dart';

void main() {
  testWidgets('kartu pemasukan memakai tanda tambah dan badge', (tester) async {
    await pumpApp(
      tester,
      TransactionCard(
        jenis: JenisKategori.pemasukan.value,
        title: AppStrings.kategori,
        subtitle: AppStrings.dompet,
        dateLabel: AppStrings.tanggal,
        jumlah: 10000,
      ),
    );

    expect(tester.getSize(find.byType(TransactionCard)), const Size(331, 94));
    final decoration = decorationOf(
      tester,
      find
          .descendant(
            of: find.byType(TransactionCard),
            matching: find.byType(DecoratedBox),
          )
          .first,
    );
    expect(decoration.color, AppColors.surface);
    expect(decoration.borderRadius, AppRadius.mdAll);
    expect(find.text('+${formatRupiah(10000)}'), findsOneWidget);
    expect(find.text(AppStrings.pemasukan), findsOneWidget);
  });

  testWidgets('kartu pengeluaran memakai tanda kurang', (tester) async {
    var taps = 0;
    await pumpApp(
      tester,
      TransactionCard(
        jenis: JenisKategori.pengeluaran.value,
        title: AppStrings.kategori,
        subtitle: AppStrings.dompet,
        dateLabel: AppStrings.tanggal,
        jumlah: 20000,
        onTap: () => taps++,
      ),
    );

    expect(find.text('-${formatRupiah(20000)}'), findsOneWidget);
    expect(find.text(AppStrings.pengeluaran), findsOneWidget);
    await tester.tap(find.byType(TransactionCard));
    await tester.pump();
    expect(taps, 1);
  });
}
