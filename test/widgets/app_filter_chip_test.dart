import 'package:dompet_mahasiswa/domain/value_objects/jenis_kategori.dart';
import 'package:dompet_mahasiswa/theme/app_colors.dart';
import 'package:dompet_mahasiswa/utils/app_strings.dart';
import 'package:dompet_mahasiswa/widgets/app_filter_chip.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/pump_app.dart';

void main() {
  testWidgets('chip terpilih berlatar primary', (tester) async {
    await pumpApp(
      tester,
      AppFilterChip(
        label: AppStrings.pemasukan,
        selected: true,
        onSelected: () {},
      ),
    );

    expect(find.text(AppStrings.pemasukan), findsOneWidget);
    expect(
      tester
          .widget<Material>(
            find
                .descendant(
                  of: find.byType(AppFilterChip),
                  matching: find.byType(Material),
                )
                .first,
          )
          .color,
      AppColors.primary,
    );
  });

  testWidgets('chip tidak terpilih berlatar lilac', (tester) async {
    await pumpApp(
      tester,
      const AppFilterChip(label: AppStrings.semua, selected: false),
    );

    expect(
      tester
          .widget<Material>(
            find
                .descendant(
                  of: find.byType(AppFilterChip),
                  matching: find.byType(Material),
                )
                .first,
          )
          .color,
      AppColors.tintLilac,
    );
  });

  testWidgets('bar filter mengembalikan nilai termasuk semua', (tester) async {
    JenisKategori? selected = JenisKategori.pemasukan;
    await pumpApp(
      tester,
      AppFilterChipBar<JenisKategori?>(
        selected: selected,
        onSelected: (value) => selected = value,
        options: const [
          AppFilterOption(value: null, label: AppStrings.semua),
          AppFilterOption(
            value: JenisKategori.pemasukan,
            label: AppStrings.pemasukan,
          ),
          AppFilterOption(
            value: JenisKategori.pengeluaran,
            label: AppStrings.pengeluaran,
          ),
        ],
      ),
    );

    await tester.tap(find.text(AppStrings.semua));
    await tester.pump();
    expect(selected, isNull);

    await tester.tap(find.text(AppStrings.pengeluaran));
    await tester.pump();
    expect(selected, JenisKategori.pengeluaran);
  });
}
