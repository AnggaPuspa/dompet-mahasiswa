import 'package:dompet_mahasiswa/theme/app_colors.dart';
import 'package:dompet_mahasiswa/theme/app_radius.dart';
import 'package:dompet_mahasiswa/theme/app_shadows.dart';
import 'package:dompet_mahasiswa/theme/app_spacing.dart';
import 'package:dompet_mahasiswa/theme/app_text_styles.dart';
import 'package:dompet_mahasiswa/widgets/periode_chips.dart';
import 'package:flutter/material.dart';

/// Panel pilih periode: Mingguan, Bulanan, Tahunan.
///
/// Lebar frame 168, tiap baris tinggi 40, sudut [AppRadius.md].
/// Baris terpilih berlatar lilac, teks tebal primary, plus ikon centang.
/// Pemanggil yang menampilkan atau menutup panel ini.
class PeriodeMenu extends StatelessWidget {
  const PeriodeMenu({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final Periode selected;
  final ValueChanged<Periode>? onSelected;

  /// Lebar frame Figma PeriodeMenu. Belum ada token space untuk 168.
  static const double frameWidth = 168;

  /// Tinggi satu baris. Belum ada token space untuk 40.
  static const double optionExtent = 40;

  static const List<Periode> options = [
    Periode.mingguan,
    Periode.bulanan,
    Periode.tahunan,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: frameWidth,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.mdAll,
          boxShadow: AppShadows.card,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < options.length; i++) ...[
                if (i > 0) const SizedBox(height: AppSpacing.s2),
                _Option(
                  periode: options[i],
                  selected: options[i] == selected,
                  onSelected: onSelected,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({
    required this.periode,
    required this.selected,
    required this.onSelected,
  });

  final Periode periode;
  final bool selected;
  final ValueChanged<Periode>? onSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.tintLilac : AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.pillAll),
      child: InkWell(
        onTap: onSelected == null ? null : () => onSelected!(periode),
        customBorder: const RoundedRectangleBorder(
          borderRadius: AppRadius.pillAll,
        ),
        child: SizedBox(
          height: PeriodeMenu.optionExtent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    periode.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: selected
                        ? AppTextStyles.bodyStrong.copyWith(
                            color: AppColors.primary,
                          )
                        : AppTextStyles.body,
                  ),
                ),
                if (selected)
                  const Icon(
                    Icons.check,
                    size: AppSpacing.s16,
                    color: AppColors.primary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
