import 'package:flutter/material.dart';

class CollectRewardsButton extends StatelessWidget {
  const CollectRewardsButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(
            width: 2,
            color: Colors.blue,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 13,
        ),
      ),
      onPressed: onPressed,
      child: const Text(
        'Collect Rewards',
      ),
    );
  }
}
