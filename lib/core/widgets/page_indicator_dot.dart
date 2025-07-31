import 'package:flutter/material.dart';

class PageIndicatorDot extends StatelessWidget {
  final bool isActive;

  const PageIndicatorDot({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? theme.colorScheme.primary : Colors.grey.shade400,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
