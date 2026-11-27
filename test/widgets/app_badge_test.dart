import 'package:dompet_mahasiswa/domain/value_objects/jenis_kategori.dart';
import 'package:dompet_mahasiswa/theme/app_colors.dart';
import 'package:dompet_mahasiswa/theme/app_radius.dart';
import 'package:dompet_mahasiswa/utils/app_strings.dart';
import 'package:dompet_mahasiswa/utils/color_helper.dart';
import 'package:dompet_mahasiswa/widgets/app_badge.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/pump_app.dart';

void main() {
  test('latar jenis mengikuti tint pemasukan dan pengeluaran', () {
    expect(
      backgroundForJenis(JenisKategori.pemasukan.value),
      AppColors.successTint,
    );
    expect(
      backgroundForJenis(JenisKategori.pengeluaran.value),
      AppColors.dangerTint,
    );
    expect(colorForJenis(JenisKategori.pemasukan.value), AppColors.success);
  });

  testWidgets('badge pemasukan tinggi 14 dan memakai warna jenis', (
    tester,
  ) async {
    await pumpApp(
      tester,
      const AppBadge(label: AppStrings.pemasukan, jenis: 'Pemasukan'),
    );

    expect(tester.getSize(find.byType(AppBadge)).height, AppBadge.frameHeight);
    final decoration = decorationOf(tester, find.byType(DecoratedBox));
    expect(decoration.color, AppColors.successTint);
    expect(decoration.borderRadius, AppRadius.smAll);
    expect(find.text(AppStrings.pemasukan), findsOneWidget);
  });

  testWidgets('badge pengeluaran memakai tint bahaya', (tester) async {
    await pumpApp(
      tester,
      AppBadge(
        label: AppStrings.pengeluaran,
        jenis: JenisKategori.pengeluaran.value,
      ),
    );

    expect(
      decorationOf(tester, find.byType(DecoratedBox)).color,
      AppColors.dangerTint,
    );
  });

  testWidgets('badge hitungan memakai warna yang diberikan pemanggil', (
    tester,
  ) async {
    await pumpApp(
      tester,
      const AppBadge(
        label: '3',
        foreground: AppColors.primary,
        background: AppColors.tintLilac,
      ),
    );

    expect(
      decorationOf(tester, find.byType(DecoratedBox)).color,
      AppColors.tintLilac,
    );
    expect(find.text('3'), findsOneWidget);
  });
}
