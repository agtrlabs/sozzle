import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BorderElevatedButton extends StatelessWidget {
  const BorderElevatedButton({
    required this.text,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    this.route,
    this.onPressed,
    super.key,
  }) : assert(
          route == null || onPressed == null,
          'Either route or onPressed must be provided, not both.',
        );

  final String text;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final String? route;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed ??
          () {
            context.go(route!);
          },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(backgroundColor),
        side: WidgetStateProperty.all(
          BorderSide(
            color: borderColor,
            width: 2,
          ),
        ),
        shape: WidgetStateProperty.all(
          const StadiumBorder(),
        ),
        // shape: MaterialStateProperty.all(
        //   RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(20),
        //   ),
        // ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
