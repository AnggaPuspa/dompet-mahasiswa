import 'package:dompet_mahasiswa/database/database_helper.dart';
import 'package:dompet_mahasiswa/domain/entities/kategori.dart';
import 'package:dompet_mahasiswa/domain/value_objects/jenis_kategori.dart';
import 'package:dompet_mahasiswa/theme/app_spacing.dart';
import 'package:dompet_mahasiswa/utils/app_strings.dart';
import 'package:dompet_mahasiswa/utils/snackbar_helper.dart';
import 'package:dompet_mahasiswa/widgets/app_button.dart';
import 'package:dompet_mahasiswa/widgets/app_text_field.dart';
import 'package:flutter/material.dart';

class KategoriFormPage extends StatefulWidget {
  const KategoriFormPage({super.key, this.category});

  final Kategori? category;

  @override
  State<KategoriFormPage> createState() => _KategoriFormPageState();
}

class _KategoriFormPageState extends State<KategoriFormPage> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.category?.nama);
  late var _type = JenisKategori.parse(
    widget.category?.jenis ?? JenisKategori.pengeluaran.value,
  );
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving || !_form.currentState!.validate()) return;
    setState(() => _saving = true);
    final category = Kategori(
      id: widget.category?.id,
      nama: _name.text.trim(),
      jenis: _type.value,
    );
    try {
      final database = DatabaseHelper.instance;
      if (category.id == null) {
        await database.insertKategori(category);
      } else {
        await database.updateKategori(category);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      showErrorSnackbar(context, AppStrings.gagalMenyimpanKategori);
    }
  }

  String? _validateName(String? value) {
    final length = (value ?? '').trim().characters.length;
    if (length == 0) return AppStrings.namaKategoriWajib;
    if (length < 2) return AppStrings.namaKategoriMin2;
    if (length > 40) return AppStrings.namaKategoriMax40;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_saving,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.category == null
                ? AppStrings.tambahKategori
                : AppStrings.ubahKategori,
          ),
        ),
        body: SafeArea(
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
                DropdownButtonFormField<JenisKategori>(
                  initialValue: _type,
                  decoration: const InputDecoration(
                    labelText: AppStrings.jenis,
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: JenisKategori.pemasukan,
                      child: Text(AppStrings.pemasukan),
                    ),
                    DropdownMenuItem(
                      value: JenisKategori.pengeluaran,
                      child: Text(AppStrings.pengeluaran),
                    ),
                  ],
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
