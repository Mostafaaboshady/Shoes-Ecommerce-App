import 'package:flutter/material.dart';
import 'custom_text.dart';

class GoogleSigninButton extends StatelessWidget {
  final String text;
  final double fontSize;
  final void Function()? onPressed;

  const GoogleSigninButton({
    super.key,
    required this.text,
    this.fontSize = 18.0,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(50.0),
          border: Border.all(
              color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
              width: 1.5),
        ),
        width: double.infinity,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/google.png',
              width: 30,
              height: 30,
            ),
            const SizedBox(width: 10.0),
            CustomText(
              text: text,
              fontSize: fontSize,
            ),
          ],
        ),
      ),
    );
  }
}
