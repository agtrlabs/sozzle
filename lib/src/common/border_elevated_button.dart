import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BorderElevatedButton extends StatelessWidget {
  const BorderElevatedButton({
    super.key,
    required this.route,
    required this.text,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
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
        backgroundColor: MaterialStateProperty.all(backgroundColor),
        side: MaterialStateProperty.all(
          BorderSide(
            color: borderColor,
            width: 2,
          ),
        ),
        shape: MaterialStateProperty.all(
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
