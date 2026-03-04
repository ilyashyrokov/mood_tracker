import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double borderRadius;
  final double height;
  final double width;
  final double verticalPadding;
  final double horizontalPadding;

  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor = Colors.white,
    this.fontSize = 17,
    this.fontWeight = FontWeight.w500,
    this.borderRadius = 25,
    this.height = 56,
    this.width = double.infinity,
    this.verticalPadding = 0,
    this.horizontalPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ??
        Theme.of(context).colorScheme.secondaryContainer;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
        minimumSize: Size(width, height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        backgroundColor: effectiveBackgroundColor,
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: textColor,
        ),
      ),
    );
  }
}
