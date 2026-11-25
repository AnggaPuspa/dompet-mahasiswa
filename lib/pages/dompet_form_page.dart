import 'package:dompet_mahasiswa/domain/value_objects/nama_dompet.dart';
import 'package:dompet_mahasiswa/theme/app_spacing.dart';
import 'package:dompet_mahasiswa/utils/app_strings.dart';
import 'package:dompet_mahasiswa/widgets/app_button.dart';
import 'package:dompet_mahasiswa/widgets/app_text_field.dart';
import 'package:flutter/material.dart';

class DompetFormPage extends StatefulWidget {
  const DompetFormPage({super.key, this.id});

  final int? id;

  @override
  State<DompetFormPage> createState() => _DompetFormPageState();
}

class _DompetFormPageState extends State<DompetFormPage> {
  final _formKey = GlobalKey<FormState>();

  String? _validasiNama(String? nilai) {
    return switch (NamaDompet.validasi(nilai ?? '')) {
      KesalahanNamaDompet.kosong => AppStrings.namaDompetWajib,
      KesalahanNamaDompet.terlaluPendek => AppStrings.namaDompetMin2,
      KesalahanNamaDompet.terlaluPanjang => AppStrings.namaDompetMax40,
      null => null,
    };
  }

  void _simpan() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.id == null ? AppStrings.tambahDompet : AppStrings.ubahDompet,
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: AppSpacing.pad16,
            children: [
              AppTextField(
                label: AppStrings.namaDompet,
                hint: AppStrings.hintNamaDompet,
                textInputAction: TextInputAction.done,
                validator: _validasiNama,
              ),
              const SizedBox(height: AppSpacing.s24),
              AppButton(label: AppStrings.simpan, onPressed: _simpan),
            ],
          ),
        ),
      ),
    );
  }
}
