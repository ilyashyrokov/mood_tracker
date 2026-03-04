import 'custom_elevated_button.dart';
import 'package:flutter/material.dart';

class PromptButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const PromptButton({super.key, required this.text, required this.onPressed});


  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(text: text, onPressed: onPressed,
    textColor:  Theme.of(context).colorScheme.secondary,
    horizontalPadding: 8,
    width: 120,
    fontSize: 13,);
  }
}
