import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    this.fontSize = 16,
    this.fontWeight,
    this.textAlign,
    this.color,
    this.overflow,
  });

  final String text;
  final double fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final defaultColor = Theme.of(context).colorScheme.onSurface;

    return Text(
      textAlign: textAlign,
      text,
      style: TextStyle(
        color: color ?? defaultColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        overflow: overflow,
      ),
    );
  }
}
