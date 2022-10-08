part of 'theme_cubit.dart';

// abstract class ThemeState {
//   Color get backgroundColor;
//   Color get primaryTextColor;
// }

// class ThemeStateDark implements ThemeState {
//   const ThemeStateDark();
//   @override
//   Color get backgroundColor => const Color(0xFF123456);
//   @override
//   Color get primaryTextColor => const Color(0xFFEEEEEE);
// }

abstract class ThemeState {}

class ThemeStateDark implements ThemeState {
  ThemeStateDark() : themeData = Themes().getDarkTheme();
  final ThemeData themeData;
}

class ThemeStateLight implements ThemeState {
  ThemeStateLight() : themeData = Themes().getLigthTheme();
  final ThemeData themeData;
}
