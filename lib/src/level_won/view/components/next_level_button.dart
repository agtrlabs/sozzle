import 'package:flutter/material.dart';

class NextLevelButton extends StatelessWidget {
  const NextLevelButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(
            width: 2,
            color: Colors.white,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 13,
        ),
      ),
      onPressed: onPressed,
      child: const Text(
        'Next Level',
      ),
    );
  }
}
