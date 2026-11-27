import 'package:dompet_mahasiswa/theme/app_colors.dart';
import 'package:dompet_mahasiswa/theme/app_theme.dart';
import 'package:dompet_mahasiswa/utils/app_assets.dart';
import 'package:dompet_mahasiswa/utils/app_strings.dart';
import 'package:dompet_mahasiswa/widgets/app_button.dart';
import 'package:dompet_mahasiswa/widgets/empty_state.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';

import '../support/pump_app.dart';

void main() {
  test('aset empty state adalah komposisi Lottie', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final data = await rootBundle.load(AppAssets.emptyState);
    final composition = await LottieComposition.fromByteData(data);
    expect(composition.duration, greaterThan(Duration.zero));
    expect(composition.layers, isNotEmpty);
  });

  testWidgets('menampilkan ilustrasi Lottie 220x176, judul, dan pesan', (
    tester,
  ) async {
    final animation = AnimationController(
      vsync: tester,
      duration: const Duration(seconds: 1),
    )..value = 0.5;
    addTearDown(animation.dispose);
    await _show(
      tester,
      EmptyState(
        title: AppStrings.belumAdaKategori,
        message: AppStrings.pesanKategoriKosong,
        actionLabel: AppStrings.tambahKategori,
        onAction: _noop,
        animation: animation,
      ),
      framed: true,
    );

    expect(find.byType(LottieBuilder), findsOneWidget);
    expect(
      tester.getSize(find.byType(LottieBuilder)),
      const Size(EmptyState.illustrationWidth, EmptyState.illustrationHeight),
    );
    final rendered = tester.widget<RawLottie>(find.byType(RawLottie));
    expect(rendered.composition, isNotNull);
    expect(rendered.composition!.layers, isNotEmpty);
    expect(rendered.composition!.duration, greaterThan(Duration.zero));
    expect(rendered.progress, closeTo(0.5, 0.02));
    expect(rendered.width, EmptyState.illustrationWidth);
    expect(rendered.height, EmptyState.illustrationHeight);
    expect(find.text(AppStrings.belumAdaKategori), findsOneWidget);
    final message = tester.widget<Text>(
      find.text(AppStrings.pesanKategoriKosong),
    );
    expect(message.style?.color, AppColors.textMuted);
    expect(find.text(AppStrings.tambahKategori), findsOneWidget);
  });

  testWidgets('ikon cadangan menggantikan ilustrasi Lottie', (tester) async {
    await pumpApp(
      tester,
      const EmptyState(
        title: AppStrings.belumAdaKategori,
        icon: Icon(Icons.inbox_outlined),
      ),
    );

    expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
    expect(find.byType(LottieBuilder), findsNothing);
    expect(find.byType(AppButton), findsNothing);
  });

  testWidgets('tombol aksi hanya tampil kalau label dan onAction ada', (
    tester,
  ) async {
    var taps = 0;
    await _show(
      tester,
      EmptyState(
        title: AppStrings.belumAdaData,
        actionLabel: AppStrings.cobaLagi,
        onAction: () => taps++,
      ),
    );
    await tester.tap(find.text(AppStrings.cobaLagi));
    await tester.pump();
    expect(taps, 1);

    await pumpApp(
      tester,
      const EmptyState(
        title: AppStrings.belumAdaData,
        actionLabel: AppStrings.cobaLagi,
      ),
    );
    expect(find.byType(AppButton), findsNothing);

    await pumpApp(
      tester,
      EmptyState(title: AppStrings.belumAdaData, onAction: () {}),
    );
    expect(find.byType(AppButton), findsNothing);
  });
}

void _noop() {}

Future<void> _show(
  WidgetTester tester,
  Widget child, {
  bool framed = false,
}) async {
  if (framed) {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          backgroundColor: AppColors.background,
          body: RepaintBoundary(key: const Key('empty-shot'), child: child),
        ),
      ),
    );
  } else {
    await pumpApp(tester, child);
  }
  await tester.pump();
  await tester.pump();
}
