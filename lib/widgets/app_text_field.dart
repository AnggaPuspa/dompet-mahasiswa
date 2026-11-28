import 'package:dompet_mahasiswa/theme/app_colors.dart';
import 'package:dompet_mahasiswa/theme/app_radius.dart';
import 'package:dompet_mahasiswa/theme/app_shadows.dart';
import 'package:dompet_mahasiswa/theme/app_spacing.dart';
import 'package:dompet_mahasiswa/theme/app_text_styles.dart';
import 'package:dompet_mahasiswa/utils/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Pembungkus [TextFormField] bergaya kartu FormField/Text.
///
/// Label ada di dalam kartu. Pesan validator tampil di bawah kartu,
/// bersama ikon peringatan, bukan di dalam garis outline.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.identifier,
    this.controller,
    this.initialValue,
    this.hint,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.readOnly = false,
    this.enabled = true,
    this.onTap,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
  });

  final String label;

  /// Identifier semantik untuk alat uji di luar Flutter. Tidak tampil di layar.
  final String? identifier;
  final TextEditingController? controller;
  final String? initialValue;
  final String? hint;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int maxLines;
  final bool readOnly;
  final bool enabled;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  /// Ukuran ikon peringatan di FormField/Error. Bukan token jarak.
  static const double errorIconExtent = 14;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  final _fieldKey = GlobalKey<FormFieldState<String>>();
  String? _error;

  void _remember(String? error) {
    if (!mounted || error == _error) {
      return;
    }
    setState(() => _error = error);
  }

  @override
  Widget build(BuildContext context) {
    final invalid = _error != null;
    final labelColor = invalid ? AppColors.danger : AppColors.textMuted;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.mdAll,
            boxShadow: AppShadows.card,
            border: invalid ? Border.all(color: AppColors.danger) : null,
          ),
          child: Padding(
            padding: AppSpacing.pad16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label,
                  style: AppTextStyles.label.copyWith(color: labelColor),
                ),
                const SizedBox(height: AppSpacing.s2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (widget.prefixIcon != null) ...[
                      widget.prefixIcon!,
                      const SizedBox(width: AppSpacing.s12),
                    ],
                    Expanded(child: _field()),
                    if (widget.suffixIcon != null) widget.suffixIcon!,
                  ],
                ),
              ],
            ),
          ),
        ),
        if (_error case final message?) ...[
          const SizedBox(height: AppSpacing.s8),
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.s4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  AppAssets.alert,
                  colorFilter: const ColorFilter.mode(
                    AppColors.danger,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: AppSpacing.s6),
                Expanded(
                  child: Text(
                    message,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.danger,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _field() {
    final field = TextFormField(
      key: _fieldKey,
      controller: widget.controller,
      initialValue: widget.controller == null ? widget.initialValue : null,
      decoration: InputDecoration(
        isCollapsed: true,
        filled: false,
        hintText: widget.hint,
        hintStyle: AppTextStyles.body.copyWith(color: AppColors.textMuted),
        contentPadding: EdgeInsets.zero,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        errorStyle: AppTextStyles.hidden,
      ),
      validator: (value) {
        final error = widget.validator?.call(value);
        _remember(error);
        return error == null ? null : '';
      },
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      maxLines: widget.maxLines,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      onTap: widget.onTap,
      onChanged: (value) {
        widget.onChanged?.call(value);
        if (_error != null) {
          _fieldKey.currentState?.validate();
        }
      },
      style: AppTextStyles.body.copyWith(
        color: widget.enabled ? AppColors.text : AppColors.textMuted,
      ),
    );
    final identifier = widget.identifier;
    if (identifier == null) {
      return field;
    }
    return Semantics(identifier: identifier, child: field);
  }
}
