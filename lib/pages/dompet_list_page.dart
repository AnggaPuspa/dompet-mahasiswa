import 'package:dompet_mahasiswa/pages/dompet_form_page.dart';
import 'package:dompet_mahasiswa/theme/app_spacing.dart';
import 'package:dompet_mahasiswa/theme/app_text_styles.dart';
import 'package:dompet_mahasiswa/utils/app_strings.dart';
import 'package:dompet_mahasiswa/utils/currency_format.dart';
import 'package:dompet_mahasiswa/widgets/app_button.dart';
import 'package:dompet_mahasiswa/widgets/app_card.dart';
import 'package:flutter/material.dart';

class DompetListPage extends StatelessWidget {
  const DompetListPage({super.key});

  void _bukaForm(BuildContext context, {int? id}) {
    Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => DompetFormPage(id: id)),
    );
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
              onPressed: () => _bukaForm(context),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.pad16,
          children: [
            AppCard(
              onTap: () => _bukaForm(context, id: 1),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          AppStrings.contohDaftarDompet,
                          style: AppTextStyles.body,
                        ),
                        const SizedBox(height: AppSpacing.s4),
                        Text(
                          formatRupiah(0),
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
            ),
          ],
        ),
      ),
    );
  }
}
