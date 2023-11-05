import 'package:flutter/material.dart';

class CustomDecorations {
  static final Decoration customDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(24),
    gradient: LinearGradient(
      // Gradient effect for a 3D-like feel
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.cyan.shade800,
        Colors.cyan.shade900,
      ],
      stops: [0.1, 0.9],
    ),
    border: Border.all(
      color: Colors.cyan.shade800,
      width: 0.5,
    ),
    boxShadow: [
      // Multiple shadows for depth
      BoxShadow(
        color: Colors.cyan.shade900.withOpacity(0.5),
        offset: Offset(-6, -6),
        blurRadius: 8.0,
        spreadRadius: 1.0,
      ),
      BoxShadow(
        color: Colors.cyan.shade100.withOpacity(0.5),
        offset: Offset(6, 6),
        blurRadius: 8.0,
        spreadRadius: 1.0,
      ),
    ],
  );
}
