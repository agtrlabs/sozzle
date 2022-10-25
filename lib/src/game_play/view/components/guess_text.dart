import 'package:flutter/material.dart';

class GuessText extends StatelessWidget {
  const GuessText(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    final alpha = text.isEmpty ? 0 : 255;
    return Material(
      color: Color.fromARGB(alpha, 50, 100, 170),
      borderRadius: const BorderRadius.all(
        Radius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
