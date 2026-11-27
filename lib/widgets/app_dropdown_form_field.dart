import 'package:dompet_mahasiswa/theme/app_colors.dart';
import 'package:dompet_mahasiswa/theme/app_radius.dart';
import 'package:dompet_mahasiswa/theme/app_shadows.dart';
import 'package:dompet_mahasiswa/theme/app_spacing.dart';
import 'package:dompet_mahasiswa/theme/app_text_styles.dart';
import 'package:dompet_mahasiswa/widgets/icon_tile.dart';
import 'package:flutter/material.dart';

/// Dropdown form. API-nya sama dengan pemakaian di form kategori:
/// [label], [options] (nilai ke teks), [onChanged], dan [initialValue].
///
/// [onChanged] null membuat field nonaktif. [validator] menampilkan pesan
/// di bawah field, sama seperti field teks. Teks opsi datang dari pemanggil.
///
/// Tampilan mengikuti FormField/Select: permukaan putih, sudut [AppRadius.md],
/// bayangan kartu, label kecil di atas nilai yang dipilih. [icon] opsional
/// ditaruh di tile 24.
class AppDropdownFormField<T> extends StatelessWidget {
  const AppDropdownFormField({
    super.key,
    required this.label,
    required this.options,
    required this.onChanged,
    this.initialValue,
    this.validator,
    this.icon,
  });

  final String label;
  final Map<T, String> options;
  final ValueChanged<T?>? onChanged;
  final T? initialValue;
  final String? Function(T?)? validator;
  final Widget? icon;

  /// Lebar frame Figma FormField/Select. Di form, field mengisi lebar induk.
  static const double frameWidth = 331;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        borderRadius: AppRadius.mdAll,
        boxShadow: AppShadows.card,
      ),
      child: DropdownButtonFormField<T>(
        initialValue: initialValue,
        isExpanded: true,
        isDense: false,
        icon: const Icon(Icons.keyboard_arrow_down),
        iconSize: AppSpacing.s24,
        iconEnabledColor: AppColors.text,
        iconDisabledColor: AppColors.textMuted,
        dropdownColor: AppColors.surface,
        borderRadius: AppRadius.mdAll,
        style: AppTextStyles.bodyStrong,
        selectedItemBuilder: (context) {
          return [
            for (final option in options.entries)
              _ClosedValue(label: label, value: option.value),
          ];
        },
        hint: _ClosedValue(label: label),
        items: [
          for (final option in options.entries)
            DropdownMenuItem<T>(
              value: option.key,
              child: Text(option.value, style: AppTextStyles.body),
            ),
        ],
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(
          errorStyle: AppTextStyles.caption.copyWith(color: AppColors.danger),
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: const EdgeInsets.fromLTRB(
            AppSpacing.s16,
            AppSpacing.s8,
            AppSpacing.s12,
            AppSpacing.s8,
          ),
          prefixIcon: icon == null
              ? null
              : Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s12,
                  ),
                  child: IconTile(
                    icon: icon,
                    background: AppColors.tintPink,
                    foreground: AppColors.accentPink,
                  ),
                ),
          border: _border(BorderSide.none),
          enabledBorder: _border(BorderSide.none),
          focusedBorder: _border(const BorderSide(color: AppColors.primary)),
          errorBorder: _border(const BorderSide(color: AppColors.danger)),
          focusedErrorBorder: _border(
            const BorderSide(color: AppColors.danger),
          ),
        ),
      ),
    );
  }

  OutlineInputBorder _border(BorderSide side) {
    return OutlineInputBorder(borderRadius: AppRadius.mdAll, borderSide: side);
  }
}

class _ClosedValue extends StatelessWidget {
  const _ClosedValue({required this.label, this.value});

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.label.copyWith(color: AppColors.textMuted),
        ),
        if (value != null) ...[
          const SizedBox(height: AppSpacing.s2),
          Text(
            value!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyStrong,
          ),
        ],
      ],
    );
  }
}
