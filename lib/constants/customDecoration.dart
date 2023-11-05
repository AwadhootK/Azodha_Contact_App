import 'package:flutter/material.dart';

class CustomDecorations {
  static final Decoration customDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(24),
    color: Colors.cyan.shade100.withOpacity(0.6),
    border: Border.all(
      color: Colors.black,
      width: 0.7,
    ),
    boxShadow: [
      BoxShadow(
        blurRadius: 5.0,
        spreadRadius: 5.0,
        color: Colors.cyan.shade900,
      ),
    ],
  );
}
