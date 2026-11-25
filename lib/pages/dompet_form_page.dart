import 'package:dompet_mahasiswa/database/database_helper.dart';
import 'package:dompet_mahasiswa/domain/entities/dompet.dart';
import 'package:dompet_mahasiswa/domain/value_objects/nama_dompet.dart';
import 'package:dompet_mahasiswa/theme/app_spacing.dart';
import 'package:dompet_mahasiswa/utils/app_strings.dart';
import 'package:dompet_mahasiswa/utils/snackbar_helper.dart';
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
  final _nama = TextEditingController();
  late bool _memuat = widget.id != null;
  bool _menyimpan = false;

  @override
  void initState() {
    super.initState();
    final id = widget.id;
    if (id != null) _muat(id);
  }

  @override
  void dispose() {
    _nama.dispose();
    super.dispose();
  }

  Future<void> _muat(int id) async {
    Dompet? dompet;
    try {
      dompet = await DatabaseHelper.instance.getDompetById(id);
    } catch (_) {
      dompet = null;
    }
    if (!mounted) return;
    if (dompet == null) {
      showErrorSnackbar(context, AppStrings.dompetTidakDitemukan);
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      return;
    }
    _nama.text = dompet.nama;
    setState(() => _memuat = false);
  }

  String? _validasiNama(String? nilai) {
    return switch (NamaDompet.validasi(nilai ?? '')) {
      KesalahanNamaDompet.kosong => AppStrings.namaDompetWajib,
      KesalahanNamaDompet.terlaluPendek => AppStrings.namaDompetMin2,
      KesalahanNamaDompet.terlaluPanjang => AppStrings.namaDompetMax40,
      null => null,
    };
  }

  Future<void> _simpan() async {
    if (_memuat || _menyimpan || !_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() => _menyimpan = true);
    final id = widget.id;
    final dompet = Dompet(id: id, nama: _nama.text.trim());
    try {
      if (id == null) {
        await DatabaseHelper.instance.insertDompet(dompet);
      } else if (await DatabaseHelper.instance.updateDompet(dompet) == 0) {
        if (!mounted) return;
        setState(() => _menyimpan = false);
        showErrorSnackbar(context, AppStrings.dompetTidakDitemukan);
        return;
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _menyimpan = false);
      showErrorSnackbar(context, AppStrings.gagalMenyimpanDompet);
      return;
    }
    if (!mounted) return;
    showSuccessSnackbar(
      context,
      id == null ? AppStrings.dompetDisimpan : AppStrings.dompetDiperbarui,
    );
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.id == null ? AppStrings.tambahDompet : AppStrings.ubahDompet,
        ),
      ),
      body: _memuat
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: AppSpacing.pad16,
                  children: [
                    AppTextField(
                      controller: _nama,
                      enabled: !_menyimpan,
                      label: AppStrings.namaDompet,
                      hint: AppStrings.hintNamaDompet,
                      textInputAction: TextInputAction.done,
                      validator: _validasiNama,
                    ),
                    const SizedBox(height: AppSpacing.s24),
                    AppButton(
                      label: AppStrings.simpan,
                      isLoading: _menyimpan,
                      onPressed: _simpan,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
