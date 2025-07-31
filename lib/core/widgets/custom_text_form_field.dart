import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.validator,
    required this.text,
    required this.textInputAction,
    this.isPassword = false,
  });

  final TextEditingController controller;
  final String? Function(String?) validator;
  final String text;
  final TextInputAction textInputAction;
  final bool isPassword;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hintColor = theme.textTheme.bodyMedium?.color;
    final enabledBorderColor = Colors.grey.shade400;
    final focusedBorderColor = theme.colorScheme.primary;
    final errorColor = theme.colorScheme.error;

    final outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(50.0),
      borderSide: BorderSide(color: enabledBorderColor, width: 1.5),
    );

    final focusedOutlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(50.0),
      borderSide: BorderSide(color: focusedBorderColor, width: 2.0),
    );

    return TextFormField(
      controller: widget.controller,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      obscureText: _obscureText,
      decoration: InputDecoration(
        border: outlineInputBorder,
        enabledBorder: outlineInputBorder,
        focusedBorder: focusedOutlineInputBorder,
        errorBorder: outlineInputBorder.copyWith(
          borderSide: BorderSide(color: errorColor, width: 1.5),
        ),
        focusedErrorBorder: outlineInputBorder.copyWith(
          borderSide: BorderSide(color: errorColor, width: 2.0),
        ),
        isDense: true,
        hintText: widget.text,
        hintStyle: TextStyle(color: hintColor),
        filled: true,
        fillColor: theme.colorScheme.surface,
        contentPadding:
        const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: hintColor,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        )
            : null,
      ),
      style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 18),
      cursorColor: theme.colorScheme.onSurface,
    );
  }
}
