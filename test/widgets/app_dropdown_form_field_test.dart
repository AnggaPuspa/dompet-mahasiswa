import 'package:dompet_mahasiswa/domain/value_objects/jenis_kategori.dart';
import 'package:dompet_mahasiswa/utils/app_strings.dart';
import 'package:dompet_mahasiswa/widgets/app_dropdown_form_field.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/pump_app.dart';

void main() {
  testWidgets('dropdown menampilkan label dan nilai, lalu berganti pilihan', (
    tester,
  ) async {
    final host = GlobalKey<_HostState>();
    await pumpApp(tester, _Host(key: host));

    expect(find.text(AppStrings.jenis), findsOneWidget);
    expect(find.text(AppStrings.pemasukan), findsWidgets);

    await tester.tap(find.byType(AppDropdownFormField<JenisKategori>));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.pengeluaran).last);
    await tester.pumpAndSettle();

    expect(host.currentState!.jenis, JenisKategori.pengeluaran);
    expect(find.text(AppStrings.pengeluaran), findsWidgets);
  });

  testWidgets('validator menampilkan pesan wajib', (tester) async {
    final host = GlobalKey<_HostState>();
    await pumpApp(tester, _Host(key: host, initial: null));

    expect(host.currentState!.formKey.currentState!.validate(), isFalse);
    await tester.pump();
    expect(find.text(AppStrings.jenisWajib), findsOneWidget);
  });

  testWidgets('onChanged null membuat dropdown nonaktif', (tester) async {
    await pumpApp(
      tester,
      AppDropdownFormField<JenisKategori>(
        label: AppStrings.jenis,
        initialValue: JenisKategori.pemasukan,
        onChanged: null,
        options: const {
          JenisKategori.pemasukan: AppStrings.pemasukan,
          JenisKategori.pengeluaran: AppStrings.pengeluaran,
        },
      ),
    );

    await tester.tap(find.byType(AppDropdownFormField<JenisKategori>));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.pengeluaran), findsNothing);
  });
}

class _Host extends StatefulWidget {
  const _Host({super.key, this.initial = JenisKategori.pemasukan});

  final JenisKategori? initial;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  final formKey = GlobalKey<FormState>();
  late JenisKategori? jenis = widget.initial;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: AppDropdownFormField<JenisKategori>(
        label: AppStrings.jenis,
        initialValue: jenis,
        options: const {
          JenisKategori.pemasukan: AppStrings.pemasukan,
          JenisKategori.pengeluaran: AppStrings.pengeluaran,
        },
        validator: (value) => value == null ? AppStrings.jenisWajib : null,
        onChanged: (value) => setState(() => jenis = value),
      ),
    );
  }
}
