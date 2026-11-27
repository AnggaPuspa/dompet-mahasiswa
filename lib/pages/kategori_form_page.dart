import 'package:dompet_mahasiswa/database/database_helper.dart';
import 'package:dompet_mahasiswa/domain/entities/kategori.dart';
import 'package:dompet_mahasiswa/domain/value_objects/jenis_kategori.dart';
import 'package:dompet_mahasiswa/domain/value_objects/nama_kategori.dart';
import 'package:dompet_mahasiswa/theme/app_spacing.dart';
import 'package:dompet_mahasiswa/utils/app_strings.dart';
import 'package:dompet_mahasiswa/utils/snackbar_helper.dart';
import 'package:dompet_mahasiswa/widgets/app_button.dart';
import 'package:dompet_mahasiswa/widgets/app_dropdown_form_field.dart';
import 'package:dompet_mahasiswa/widgets/app_text_field.dart';
import 'package:flutter/material.dart';

class KategoriFormPage extends StatefulWidget {
  const KategoriFormPage({super.key, this.id});

  final int? id;

  @override
  State<KategoriFormPage> createState() => _KategoriFormPageState();
}

class _KategoriFormPageState extends State<KategoriFormPage> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  JenisKategori? _type;
  late bool _loading = widget.id != null;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.id != null) _load();
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final category = await DatabaseHelper.instance.getKategoriById(
        widget.id!,
      );
      if (!mounted) return;
      if (category == null) {
        _leaveMissing();
        return;
      }
      _name.text = category.nama;
      _type = JenisKategori.parse(category.jenis);
      setState(() => _loading = false);
    } catch (_) {
      if (!mounted) return;
      _leaveMissing();
    }
  }

  void _leaveMissing() {
    showErrorSnackbar(context, AppStrings.kategoriTidakDitemukan);
    Navigator.pop(context);
  }

  Future<void> _save() async {
    if (_saving || !_form.currentState!.validate()) return;
    setState(() => _saving = true);
    final id = widget.id;
    final category = Kategori(
      id: id,
      nama: _name.text.trim(),
      jenis: _type!.value,
    );
    try {
      final database = DatabaseHelper.instance;
      if (id == null) {
        await database.insertKategori(category);
      } else {
        await database.updateKategori(category);
      }
      if (!mounted) return;
      showSuccessSnackbar(
        context,
        id == null
            ? AppStrings.kategoriDisimpan
            : AppStrings.kategoriDiperbarui,
      );
      Navigator.pop(context, true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      showErrorSnackbar(context, AppStrings.gagalMenyimpanKategori);
    }
  }

  String? _validateName(String? value) {
    return switch (NamaKategori.validasi(value ?? '')) {
      KesalahanNamaKategori.kosong => AppStrings.namaKategoriWajib,
      KesalahanNamaKategori.terlaluPendek => AppStrings.namaKategoriMin2,
      KesalahanNamaKategori.terlaluPanjang => AppStrings.namaKategoriMax40,
      null => null,
    };
  }

  String? _validateType(JenisKategori? value) {
    if (value == null) return AppStrings.jenisWajib;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_saving,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.id == null
                ? AppStrings.tambahKategori
                : AppStrings.ubahKategori,
          ),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: Form(
                  key: _form,
                  child: ListView(
                    padding: const EdgeInsets.all(AppSpacing.s22),
                    children: [
                      AppTextField(
                        label: AppStrings.namaKategori,
                        hint: AppStrings.hintNamaKategori,
                        controller: _name,
                        enabled: !_saving,
                        validator: _validateName,
                      ),
                      const SizedBox(height: AppSpacing.s16),
                      AppDropdownFormField<JenisKategori>(
                        initialValue: _type,
                        label: AppStrings.jenis,
                        options: const {
                          JenisKategori.pemasukan: AppStrings.pemasukan,
                          JenisKategori.pengeluaran: AppStrings.pengeluaran,
                        },
                        validator: _validateType,
                        onChanged: _saving
                            ? null
                            : (type) {
                                if (type != null) setState(() => _type = type);
                              },
                      ),
                      const SizedBox(height: AppSpacing.s24),
                      AppButton(
                        label: AppStrings.simpan,
                        isLoading: _saving,
                        onPressed: _save,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
