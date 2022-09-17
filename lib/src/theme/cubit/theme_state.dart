part of 'theme_cubit.dart';

abstract class ThemeState {
  ThemeState();
  Color get backgroundColor;
  Color get primaryTextColor;
}

class ThemeStateDark implements ThemeState {
  const ThemeStateDark();
  @override
  Color get backgroundColor => const Color(0xFF123456);
  @override
  Color get primaryTextColor => const Color(0xFFEEEEEE);
}
