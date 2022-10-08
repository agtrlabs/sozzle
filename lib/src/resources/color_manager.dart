import 'package:flutter/material.dart';

enum ThemeMode { light, dark }

class ColorManager {
  static Color primaryLight = HexColor.fromHex('#ED9728');
  static Color white = Colors.white;
  static Color blue = Colors.blue;
  static Color lightBlue = Colors.blue.shade200;
  static Color darkBlue = Colors.blue.shade800;
  static Color lightViolet = Colors.purple.shade300;

  static Color darkGrey = HexColor.fromHex('#525252');
  static Color grey = HexColor.fromHex('#737477');
  static Color lightGrey = HexColor.fromHex('#9E9E9E');
  static Color primaryOpacity70 = HexColor.fromHex('#B3Ed9728');

  static Color darkPrimary = HexColor.fromHex('#d17d11');
  static Color grey1 = HexColor.fromHex('#707070');
  static Color grey2 = HexColor.fromHex('#797979');

  static Color error = HexColor.fromHex('#e61f34'); // red color
  static Color black = HexColor.fromHex('#000000');
}

extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll('#', '');
    if (hexColorString.length == 6) {
      hexColorString = 'FF$hexColorString';
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}
