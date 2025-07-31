import 'dart:ui';

import 'package:flutter/material.dart';
class CircleBlob extends StatelessWidget {
  final Color color;
  final double radius;

  const CircleBlob({super.key, required this.color, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
        child: Container(
          color: Colors.transparent,
        ),
      ),
    );
  }
}