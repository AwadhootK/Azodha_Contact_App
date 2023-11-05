import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData prefixIcon;
  final String? Function(String?)? validator;
  final void Function()? onEditingComplete;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String labelText;
  final int maxLines;

  CustomTextField({
    super.key,
    required this.controller,
    required this.prefixIcon,
    required this.validator,
    this.keyboardType = TextInputType.name,
    this.textInputAction = TextInputAction.next,
    this.labelText = '',
    this.maxLines = 1,
    this.onEditingComplete = null,
  });

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: h * 0.015),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            color: Colors.cyan.shade700,
            fontWeight: FontWeight.bold,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.cyan.shade300, width: 2.0),
            borderRadius: BorderRadius.circular(25.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.cyan.shade700, width: 2.5),
            borderRadius: BorderRadius.circular(25.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red.shade700, width: 2.0),
            borderRadius: BorderRadius.circular(25.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red.shade700, width: 2.5),
            borderRadius: BorderRadius.circular(25.0),
          ),
          filled: true,
          fillColor: Colors.cyan.shade50,
          prefixIcon: Icon(
            prefixIcon,
            color: Colors.cyan.shade700,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.cyan.shade700,
                  ),
                  onPressed: () {
                    controller.clear();
                  },
                )
              : null,
        ),
        validator: validator,
        onEditingComplete: onEditingComplete,
      ),
    );
  }
}
