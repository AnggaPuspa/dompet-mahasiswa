import 'package:dompet_mahasiswa/theme/app_colors.dart';
import 'package:dompet_mahasiswa/theme/app_radius.dart';
import 'package:dompet_mahasiswa/utils/app_strings.dart';
import 'package:dompet_mahasiswa/widgets/app_button.dart';
import 'package:dompet_mahasiswa/widgets/confirm_dialog.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/pump_app.dart';

void main() {
  testWidgets('varian info menampilkan Mengerti dan mengembalikan true', (
    tester,
  ) async {
    await _open(tester, variant: ConfirmDialogVariant.info);

    expect(find.text(AppStrings.kategoriTidakBisaDihapusJudul), findsOneWidget);
    expect(find.text(AppStrings.mengerti), findsOneWidget);
    expect(find.text(AppStrings.batal), findsNothing);
    expect(find.byIcon(Icons.priority_high), findsOneWidget);
    final button = tester.widget<AppButton>(
      find.widgetWithText(AppButton, AppStrings.mengerti),
    );
    expect(button.variant, AppButtonVariant.primary);
    expect(_badgeColor(tester), AppColors.tintOrange);

    await tester.tap(find.text(AppStrings.mengerti));
    await _frames(tester);
    expect(_results, [true]);
  });

  testWidgets('tutup di luar dialog info mengembalikan false', (tester) async {
    await _open(tester, variant: ConfirmDialogVariant.info);
    await tester.tapAt(const Offset(8, 8));
    await _frames(tester);
    expect(_results, [false]);
  });

  testWidgets('varian danger membedakan batal dan hapus', (tester) async {
    await _open(tester);
    expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    final hapus = tester.widget<AppButton>(
      find.widgetWithText(AppButton, AppStrings.hapus),
    );
    final batal = tester.widget<AppButton>(
      find.widgetWithText(AppButton, AppStrings.batal),
    );
    expect(hapus.variant, AppButtonVariant.danger);
    expect(batal.variant, AppButtonVariant.secondary);
    expect(find.bySemanticsIdentifier('konfirmasi_dialog'), findsOneWidget);
    expect(_badgeColor(tester), AppColors.dangerTint);

    await tester.tap(find.text(AppStrings.batal));
    await _frames(tester);
    expect(_results, [false]);

    await tester.tap(find.text(AppStrings.tambah));
    await _frames(tester);
    await tester.tap(find.text(AppStrings.hapus));
    await _frames(tester);
    expect(_results, [false, true]);
  });

  testWidgets('varian primary memakai tombol primary', (tester) async {
    await _open(tester, isDanger: false);
    final confirm = tester.widget<AppButton>(
      find.widgetWithText(AppButton, AppStrings.hapus),
    );
    expect(confirm.variant, AppButtonVariant.primary);
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    expect(_badgeColor(tester), AppColors.primaryTint);

    await tester.binding.handlePopRoute();
    await _frames(tester);
    expect(_results, [false]);
  });
}

final List<bool> _results = [];

Future<void> _open(
  WidgetTester tester, {
  ConfirmDialogVariant? variant,
  bool isDanger = true,
}) async {
  _results.clear();
  tester.view.physicalSize = const Size(375, 812);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await pumpApp(
    tester,
    Builder(
      builder: (context) {
        return AppButton(
          label: AppStrings.tambah,
          isExpanded: false,
          onPressed: () async {
            _results.add(
              await ConfirmDialog.show(
                context,
                title: variant == ConfirmDialogVariant.info
                    ? AppStrings.kategoriTidakBisaDihapusJudul
                    : AppStrings.hapusKategoriJudul,
                message: variant == ConfirmDialogVariant.info
                    ? AppStrings.kategoriTidakBisaDihapus
                    : AppStrings.hapusKategoriPesan,
                variant: variant,
                isDanger: isDanger,
              ),
            );
          },
        );
      },
    ),
  );
  await tester.tap(find.text(AppStrings.tambah));
  await _frames(tester);
}

Future<void> _frames(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

Color? _badgeColor(WidgetTester tester) {
  for (final box in tester.widgetList<DecoratedBox>(
    find.byType(DecoratedBox),
  )) {
    final decoration = box.decoration;
    if (decoration is BoxDecoration &&
        decoration.borderRadius == AppRadius.fullAll &&
        decoration.color != null &&
        decoration.color != AppColors.primary) {
      return decoration.color;
    }
  }
  return null;
}
