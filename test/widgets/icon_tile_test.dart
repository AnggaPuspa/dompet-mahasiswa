import 'package:dompet_mahasiswa/theme/app_colors.dart';
import 'package:dompet_mahasiswa/theme/app_radius.dart';
import 'package:dompet_mahasiswa/theme/app_spacing.dart';
import 'package:dompet_mahasiswa/utils/app_strings.dart';
import 'package:dompet_mahasiswa/widgets/icon_tile.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/pump_app.dart';

void main() {
  testWidgets('tile edit berukuran 24 dan berlatar lilac', (tester) async {
    await pumpApp(tester, const IconTile(variant: IconTileVariant.edit));

    expect(
      tester.getSize(find.byType(IconTile)),
      const Size.square(AppSpacing.s24),
    );
    final decoration = decorationOf(tester, find.byType(DecoratedBox));
    expect(decoration.color, AppColors.tintLilac);
    expect(decoration.borderRadius, AppRadius.smAll);
    expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
  });

  testWidgets('tile hapus berlatar danger', (tester) async {
    await pumpApp(tester, const IconTile(variant: IconTileVariant.delete));

    expect(
      decorationOf(tester, find.byType(DecoratedBox)).color,
      AppColors.dangerTint,
    );
    expect(find.byIcon(Icons.delete_outline), findsOneWidget);
  });

  testWidgets('ikon dan latar kustom menggantikan varian', (tester) async {
    await pumpApp(
      tester,
      const IconTile(
        icon: Icon(Icons.add),
        background: AppColors.tintSky,
        foreground: AppColors.accentBlue,
      ),
    );

    expect(
      decorationOf(tester, find.byType(DecoratedBox)).color,
      AppColors.tintSky,
    );
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('tombol ikon memanggil aksi dan punya tooltip ubah', (
    tester,
  ) async {
    var taps = 0;
    await pumpApp(
      tester,
      AppIconButton(variant: IconTileVariant.edit, onPressed: () => taps++),
    );

    expect(find.byTooltip(AppStrings.ubah), findsOneWidget);
    await tester.tap(find.byType(AppIconButton));
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('tombol hapus nonaktif tidak memanggil aksi', (tester) async {
    var taps = 0;
    await pumpApp(
      tester,
      AppIconButton(variant: IconTileVariant.delete, onPressed: null),
    );

    expect(find.byTooltip(AppStrings.hapus), findsOneWidget);
    await tester.tap(find.byType(AppIconButton));
    await tester.pump();
    expect(taps, 0);
  });
}
