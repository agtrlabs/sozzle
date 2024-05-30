import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BorderElevatedButton extends StatelessWidget {
  const BorderElevatedButton({
    required this.route,
    required this.text,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    super.key,
  });

  final String route;
  final String text;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.go(route);
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
