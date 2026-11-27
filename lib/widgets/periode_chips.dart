import 'package:dompet_mahasiswa/theme/app_colors.dart';
import 'package:dompet_mahasiswa/theme/app_radius.dart';
import 'package:dompet_mahasiswa/theme/app_shadows.dart';
import 'package:dompet_mahasiswa/theme/app_spacing.dart';
import 'package:dompet_mahasiswa/theme/app_text_styles.dart';
import 'package:dompet_mahasiswa/utils/app_strings.dart';
import 'package:flutter/material.dart';

/// Mode periode di chip dan menu. Labelnya ada di [AppStrings].
enum Periode {
  mingguan,
  bulanan,
  tahunan;

  String get label => switch (this) {
    Periode.mingguan => AppStrings.periodeMingguan,
    Periode.bulanan => AppStrings.periodeBulanan,
    Periode.tahunan => AppStrings.periodeTahunan,
  };
}

/// Satu kartu di dalam [PeriodeChips]. Teks diisi pemanggil.
class PeriodeChipData {
  const PeriodeChipData({
    required this.id,
    required this.main,
    required this.bottom,
    this.top,
  });

  final String id;
  final String? top;
  final String main;
  final String bottom;
}

/// Deretan kartu periode (bulanan 64×84, mingguan/tahunan 84×84).
///
/// Kartu terpilih berlatar primary tanpa bayangan. Yang lain berlatar
/// permukaan dengan [AppShadows.card]. Jarak antar kartu [AppSpacing.s12].
class PeriodeChips extends StatelessWidget {
  const PeriodeChips({
    super.key,
    required this.periode,
    required this.items,
    required this.selectedId,
    this.onSelected,
  });

  final Periode periode;
  final List<PeriodeChipData> items;
  final String? selectedId;
  final ValueChanged<String>? onSelected;

  static const double frameHeight = 84;

  /// Lebar kartu bulan. Belum ada token space untuk 64.
  static const double monthWidth = 64;

  /// Lebar kartu minggu dan tahun. Sama dengan tinggi frame.
  static const double squareExtent = 84;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.s12),
            _PeriodeCard(
              data: items[i],
              width: _width,
              selected: items[i].id == selectedId,
              onSelected: onSelected,
            ),
          ],
        ],
      ),
    );
  }

  double get _width {
    return switch (periode) {
      Periode.bulanan => monthWidth,
      Periode.mingguan || Periode.tahunan => squareExtent,
    };
  }
}

class _PeriodeCard extends StatelessWidget {
  const _PeriodeCard({
    required this.data,
    required this.width,
    required this.selected,
    required this.onSelected,
  });

  final PeriodeChipData data;
  final double width;
  final bool selected;
  final ValueChanged<String>? onSelected;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.onPrimary : AppColors.text;
    final caption = AppTextStyles.caption.copyWith(color: color);
    final main = AppTextStyles.heading19.copyWith(color: color);
    return SizedBox(
      width: width,
      height: PeriodeChips.frameHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: AppRadius.mdAll,
          boxShadow: selected ? null : AppShadows.card,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onSelected == null ? null : () => onSelected!(data.id),
            borderRadius: AppRadius.mdAll,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.s8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (data.top != null)
                    Text(
                      data.top!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: caption,
                    ),
                  if (data.top != null) const SizedBox(height: AppSpacing.s8),
                  Text(
                    data.main,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: main,
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  Text(
                    data.bottom,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: caption,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
