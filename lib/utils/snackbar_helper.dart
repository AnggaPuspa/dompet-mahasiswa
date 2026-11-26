import 'package:dompet_mahasiswa/theme/app_colors.dart';
import 'package:dompet_mahasiswa/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

void showSuccessSnackbar(BuildContext context, String message) {
  _showSnackbar(context, message, AppColors.successTint);
}

void showErrorSnackbar(BuildContext context, String message) {
  _showSnackbar(context, message, AppColors.dangerTint);
}

void showInfoSnackbar(BuildContext context, String message) {
  _showSnackbar(context, message, AppColors.primaryTint);
}

void _showSnackbar(BuildContext context, String message, Color background) {
  ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message, style: AppTextStyles.body),
        backgroundColor: background,
      ),
    );
}
