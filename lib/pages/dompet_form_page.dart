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
            children: const [
              AppTextField(
                label: AppStrings.namaDompet,
                hint: AppStrings.hintNamaDompet,
                textInputAction: TextInputAction.done,
              ),
              SizedBox(height: AppSpacing.s24),
              AppButton(label: AppStrings.simpan, onPressed: null),
            ],
          ),
        ),
      ),
    );
  }
}
