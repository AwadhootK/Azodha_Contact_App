import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final TextEditingController imageController;
  final void Function()? onPressed;
  final int imageType;
  final String text;
  final IconData prefixIcon;
  final int imageNumber;

  const CustomTextButton({
    super.key,
    required this.imageController,
    required this.onPressed,
    required this.imageType,
    required this.text,
    required this.prefixIcon,
    required this.imageNumber,
  });

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: imageType == imageNumber
            ? Colors.cyan.shade900
            : Colors.cyan.shade100,
        side: BorderSide(
          color: imageType == imageNumber
              ? Colors.cyan.shade100
              : Colors.cyan.shade900,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 1, // Adds shadow
        padding:
            EdgeInsets.symmetric(horizontal: h * 0.015, vertical: h * 0.015),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            prefixIcon,
            color: imageType == imageNumber
                ? Colors.cyan.shade100
                : Colors.cyan.shade900,
            size: 20,
          ),
          SizedBox(width: h * 0.01),
          Text(
            text,
            style: TextStyle(
              color: imageType == imageNumber
                  ? Colors.cyan.shade100
                  : Colors.cyan.shade900,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
