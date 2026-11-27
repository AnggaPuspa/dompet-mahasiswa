import 'package:dompet_mahasiswa/theme/app_colors.dart';
import 'package:dompet_mahasiswa/theme/app_radius.dart';
import 'package:dompet_mahasiswa/theme/app_spacing.dart';
import 'package:dompet_mahasiswa/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Satu pilihan di bar filter. [value] boleh null, misalnya "Semua".
class AppFilterOption<T> {
  const AppFilterOption({required this.value, required this.label});

  final T value;
  final String label;
}

/// Chip pil Figma (Chip/Selected dan Chip/Default).
///
/// Pengganti `ChoiceChip` mentah. Terpilih: latar primary, teks putih tebal.
/// Tidak terpilih: latar lilac, teks primary.
class AppFilterChip extends StatelessWidget {
  const AppFilterChip({
    super.key,
    required this.label,
    required this.selected,
    this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback? onSelected;

  @override
  Widget build(BuildContext context) {
    final background = selected ? AppColors.primary : AppColors.tintLilac;
    final foreground = selected ? AppColors.onPrimary : AppColors.primary;
    final style = (selected ? AppTextStyles.bodyStrong : AppTextStyles.body)
        .copyWith(color: foreground);

    return Material(
      color: background,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.pillAll),
      child: InkWell(
        onTap: onSelected,
        customBorder: const RoundedRectangleBorder(
          borderRadius: AppRadius.pillAll,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s24,
            vertical: AppSpacing.s8,
          ),
          child: Text(label, style: style),
        ),
      ),
    );
  }
}

/// Deretan [AppFilterChip] dengan jarak [AppSpacing.s12].
///
/// Keluarga yang sama dengan PeriodeChips: ini filter pil (Semua /
/// Pemasukan / Pengeluaran), PeriodeChips adalah kartu periode.
///
/// Contoh pengganti filter daftar kategori:
/// ```dart
/// AppFilterChipBar<JenisKategori?>(
///   options: [
///     AppFilterOption(value: null, label: AppStrings.semua),
///     AppFilterOption(
///       value: JenisKategori.pemasukan,
///       label: AppStrings.pemasukan,
///     ),
///     AppFilterOption(
///       value: JenisKategori.pengeluaran,
///       label: AppStrings.pengeluaran,
///     ),
///   ],
///   selected: filter,
///   onSelected: (value) => setState(() => filter = value),
/// )
/// ```
class AppFilterChipBar<T> extends StatelessWidget {
  const AppFilterChipBar({
    super.key,
    required this.options,
    required this.selected,
    this.onSelected,
  });

  final List<AppFilterOption<T>> options;
  final T selected;
  final ValueChanged<T>? onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < options.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.s12),
            AppFilterChip(
              label: options[i].label,
              selected: options[i].value == selected,
              onSelected: onSelected == null
                  ? null
                  : () => onSelected!(options[i].value),
            ),
          ],
        ],
      ),
    );
  }
}
