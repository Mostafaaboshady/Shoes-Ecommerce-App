import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final bool isSearchField;
  final bool isPassword;
  final bool enabled;
  final bool readOnly;
  final bool obscureText;
  final VoidCallback? onTogglePasswordVisibility;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    this.controller,
    required this.hintText,
    this.isSearchField = false,
    this.isPassword = false,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.onTogglePasswordVisibility,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hintColor = theme.textTheme.bodyMedium?.color;
    final enabledBorderColor = Colors.grey.shade400;
    final focusedBorderColor = theme.colorScheme.primary;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      obscureText: obscureText,
      enabled: enabled,
      readOnly: readOnly,
      decoration: InputDecoration(
        prefixIcon: isSearchField
            ? Icon(Icons.search, size: 25, color: hintColor)
            : null,
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: hintColor),
          onPressed: onTogglePasswordVisibility,
        )
            : null,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(color: enabledBorderColor, width: 1.5)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(color: enabledBorderColor, width: 1.5)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(color: focusedBorderColor, width: 1.5)),
        fillColor: (enabled && !readOnly)
            ? theme.colorScheme.surface
            : theme.scaffoldBackgroundColor,
        isDense: true,
        hintText: hintText,
        hintStyle: TextStyle(color: hintColor, fontSize: 16),
        filled: true,
        contentPadding:
        const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
      ),
      style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 16),
      cursorColor: theme.colorScheme.onSurface,
    );
  }
}
