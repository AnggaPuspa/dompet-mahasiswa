import 'package:dompet_mahasiswa/theme/app_colors.dart';
import 'package:dompet_mahasiswa/theme/app_spacing.dart';
import 'package:dompet_mahasiswa/utils/app_strings.dart';
import 'package:dompet_mahasiswa/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpButton(
    WidgetTester tester,
    AppButton button, {
    Size view = const Size(375, 812),
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = view;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s22),
            child: Align(alignment: Alignment.topCenter, child: button),
          ),
        ),
      ),
    );
  }

  bool hasGlow(WidgetTester tester) {
    return find
        .descendant(
          of: find.byType(AppButton),
          matching: find.byType(ImageFiltered),
        )
        .evaluate()
        .isNotEmpty;
  }

  testWidgets('primer setinggi 52, mengisi lebar, dan punya glow', (
    tester,
  ) async {
    await pumpButton(
      tester,
      AppButton(label: AppStrings.simpan, onPressed: () {}),
    );

    expect(
      tester.getSize(find.byType(AppButton)),
      const Size(331, AppButton.frameHeight),
    );
    expect(hasGlow(tester), isTrue);
    expect(_faceColor(tester), AppColors.primary);
  });

  testWidgets('di layar lebar tombol tetap mengisi induk, bukan mentok 331', (
    tester,
  ) async {
    await pumpButton(
      tester,
      AppButton(label: AppStrings.tambahDompet, onPressed: () {}),
      view: const Size(600, 800),
    );

    expect(
      tester.getSize(find.byType(AppButton)).width,
      600 - AppSpacing.s22 * 2,
    );
    expect(
      tester.getSize(find.byType(AppButton)).height,
      AppButton.frameHeight,
    );
  });

  testWidgets('sekunder lilac tanpa glow, nonaktif tanpa glow', (tester) async {
    await pumpButton(
      tester,
      AppButton(
        label: AppStrings.tambahKategoriAksi,
        variant: AppButtonVariant.secondary,
        onPressed: () {},
      ),
    );

    expect(hasGlow(tester), isFalse);
    expect(_faceColor(tester), AppColors.tintLilac);

    await pumpButton(
      tester,
      const AppButton(label: AppStrings.simpan, onPressed: null),
    );
    expect(hasGlow(tester), isFalse);
    expect(_faceColor(tester), AppColors.outline);
  });
}

Color _faceColor(WidgetTester tester) {
  return tester
      .widget<Material>(
        find.descendant(
          of: find.byType(AppButton),
          matching: find.byType(Material),
        ),
      )
      .color!;
}
