import 'package:dompet_mahasiswa/database/database_helper.dart';
import 'package:dompet_mahasiswa/pages/dompet_form_page.dart';
import 'package:dompet_mahasiswa/theme/app_spacing.dart';
import 'package:dompet_mahasiswa/theme/app_text_styles.dart';
import 'package:dompet_mahasiswa/utils/app_strings.dart';
import 'package:dompet_mahasiswa/utils/currency_format.dart';
import 'package:dompet_mahasiswa/widgets/app_button.dart';
import 'package:dompet_mahasiswa/widgets/app_card.dart';
import 'package:flutter/material.dart';

typedef _BarisDompet = ({int id, String nama, int saldo});

class DompetListPage extends StatefulWidget {
  const DompetListPage({super.key});

  static const routeName = '/dompet';

  @override
  State<DompetListPage> createState() => _DompetListPageState();
}

class _DompetListPageState extends State<DompetListPage> {
  late Future<List<_BarisDompet>> _daftar = _muatDaftar();

  Future<List<_BarisDompet>> _muatDaftar() async {
    final database = DatabaseHelper.instance;
    final dompet = await database.getAllDompet();
    return Future.wait(
      dompet.map((item) async {
        final id = item.id!;
        final saldo = await database.getSaldoDompet(id);
        return (id: id, nama: item.nama, saldo: saldo);
      }),
    );
  }

  void _segarkan() => setState(() => _daftar = _muatDaftar());

  Future<void> _bukaForm({int? id}) async {
    final disimpan = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => DompetFormPage(id: id)),
    );
    if (mounted && disimpan == true) _segarkan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.dompet),
        actions: [
          Padding(
            padding: AppSpacing.horizontal16,
            child: AppButton(
              label: AppStrings.tambah,
              variant: AppButtonVariant.secondary,
              isExpanded: false,
              onPressed: _bukaForm,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<List<_BarisDompet>>(
          future: _daftar,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text(AppStrings.gagalMemuatDompet));
            }
            final daftar = snapshot.requireData;
            return ListView.separated(
              padding: AppSpacing.pad16,
              itemCount: daftar.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSpacing.s12),
              itemBuilder: (context, index) => _kartu(daftar[index]),
            );
          },
        ),
      ),
    );
  }

  Widget _kartu(_BarisDompet item) {
    return AppCard(
      onTap: () => _bukaForm(id: item.id),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.nama, style: AppTextStyles.body),
                const SizedBox(height: AppSpacing.s4),
                Text(
                  formatRupiah(item.saldo),
                  style: AppTextStyles.captionStrong,
                ),
              ],
            ),
          ),
          const IconButton(
            tooltip: AppStrings.hapus,
            onPressed: null,
            icon: Icon(Icons.delete_outline),
          ),
        ],
      ),
    );
  }
}
