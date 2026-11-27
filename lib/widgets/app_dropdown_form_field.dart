import 'package:flutter/material.dart';

class AppDropdownFormField<T> extends StatelessWidget {
  const AppDropdownFormField({
    super.key,
    required this.label,
    required this.options,
    required this.onChanged,
    this.initialValue,
  });

  final String label;
  final Map<T, String> options;
  final ValueChanged<T?>? onChanged;
  final T? initialValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: initialValue,
      decoration: InputDecoration(labelText: label),
      isExpanded: true,
      items: [
        for (final option in options.entries)
          DropdownMenuItem(value: option.key, child: Text(option.value)),
      ],
      onChanged: onChanged,
    );
  }
}
