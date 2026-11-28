import 'package:dompet_mahasiswa/domain/value_objects/jenis_kategori.dart';
import 'package:dompet_mahasiswa/theme/app_colors.dart';
import 'package:dompet_mahasiswa/theme/app_radius.dart';
import 'package:dompet_mahasiswa/theme/app_shadows.dart';
import 'package:dompet_mahasiswa/theme/app_spacing.dart';
import 'package:dompet_mahasiswa/theme/app_text_styles.dart';
import 'package:dompet_mahasiswa/utils/app_strings.dart';
import 'package:flutter/material.dart';

/// Dua kartu radio Pemasukan / Pengeluaran untuk form kategori.
///
/// Bagian dari [Form], jadi [validator] ikut [FormState.validate].
class AppJenisField extends FormField<JenisKategori> {
  AppJenisField({
    super.key,
    required String label,
    JenisKategori? value,
    ValueChanged<JenisKategori>? onChanged,
    super.validator,
    bool enabled = true,
  }) : super(
         initialValue: value,
         builder: (state) {
           return Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Text(label, style: AppTextStyles.caption),
               const SizedBox(height: AppSpacing.s10),
               Row(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   for (final jenis in JenisKategori.values) ...[
                     if (jenis != JenisKategori.values.first)
                       const SizedBox(width: AppSpacing.s16),
                     Expanded(
                       child: _JenisOption(
                         label: _label(jenis),
                         selected: state.value == jenis,
                         onTap: enabled
                             ? () {
                                 state.didChange(jenis);
                                 onChanged?.call(jenis);
                                 state.validate();
                               }
                             : null,
                       ),
                     ),
                   ],
                 ],
               ),
               if (state.errorText case final message?) ...[
                 const SizedBox(height: AppSpacing.s10),
                 Text(
                   message,
                   style: AppTextStyles.caption.copyWith(
                     color: AppColors.danger,
                   ),
                 ),
               ],
             ],
           );
         },
       );

  static String _label(JenisKategori jenis) {
    return switch (jenis) {
      JenisKategori.pemasukan => AppStrings.pemasukan,
      JenisKategori.pengeluaran => AppStrings.pengeluaran,
    };
  }
}

class _JenisOption extends StatelessWidget {
  const _JenisOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        borderRadius: AppRadius.mdAll,
        boxShadow: AppShadows.card,
      ),
      child: Material(
        color: selected ? AppColors.tintLilac : AppColors.surface,
        borderRadius: AppRadius.mdAll,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            children: [
              Padding(
                padding: AppSpacing.pad16,
                child: Row(
                  children: [
                    _RadioMark(selected: selected),
                    const SizedBox(width: AppSpacing.s10),
                    Flexible(
                      child: Text(
                        label,
                        style:
                            (selected
                                    ? AppTextStyles.bodyStrong
                                    : AppTextStyles.body)
                                .copyWith(
                                  color: selected
                                      ? AppColors.primary
                                      : AppColors.text,
                                ),
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                const Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: AppRadius.mdAll,
                        border: Border.fromBorderSide(
                          BorderSide(color: AppColors.primary),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RadioMark extends StatelessWidget {
  const _RadioMark({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.s20,
      height: AppSpacing.s20,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.primarySoft,
            width: AppSpacing.s2,
          ),
        ),
        child: selected
            ? const Center(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: SizedBox(
                    width: AppSpacing.s10,
                    height: AppSpacing.s10,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
