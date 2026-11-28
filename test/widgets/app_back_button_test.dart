import 'package:dompet_mahasiswa/theme/app_colors.dart';
import 'package:dompet_mahasiswa/theme/app_spacing.dart';
import 'package:dompet_mahasiswa/utils/app_assets.dart';
import 'package:dompet_mahasiswa/utils/app_strings.dart';
import 'package:dompet_mahasiswa/widgets/app_back_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/pump_app.dart';

void main() {
  testWidgets('ikon kembali memakai aset panah dan token warna', (
    tester,
  ) async {
    await pumpApp(tester, const AppBackButton());

    final svg = tester.widget<SvgPicture>(find.byType(SvgPicture));
    final loader = svg.bytesLoader as SvgAssetLoader;
    expect(loader.assetName, AppAssets.arrowLeft);
    expect(
      svg.colorFilter,
      const ColorFilter.mode(AppColors.icon, BlendMode.srcIn),
    );
    expect(
      tester.getSize(find.byType(SvgPicture)),
      const Size.square(AppSpacing.s24),
    );
    expect(find.byTooltip(AppStrings.kembali), findsOneWidget);
  });

  testWidgets('menutup halaman yang sedang terbuka', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const Scaffold(body: AppBackButton()),
                    ),
                  );
                },
                child: const Text('buka'),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('buka'));
    await tester.pumpAndSettle();
    expect(find.byType(AppBackButton), findsOneWidget);

    await tester.tap(find.byType(AppBackButton));
    await tester.pumpAndSettle();
    expect(find.byType(AppBackButton), findsNothing);
    expect(find.text('buka'), findsOneWidget);
  });

  testWidgets('nonaktif tidak menutup halaman', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: AppBackButton(enabled: false))),
    );

    await tester.tap(find.byType(AppBackButton));
    await tester.pumpAndSettle();
    expect(find.byType(AppBackButton), findsOneWidget);
  });
}
