part of 'theme_cubit.dart';

abstract class ThemeState {
  Color get backgroundColor;
  Color get primaryTextColor;
  Color get appBarColor;
  Color get accentColor;
  MaterialColor get primarySwatch;
}

class ThemeStateDark implements ThemeState {
  const ThemeStateDark();
  @override
  Color get backgroundColor => const Color(0xFF123456);

  @override
  Color get primaryTextColor => const Color(0xFFEEEEEE);

  @override
  Color get appBarColor => const Color(0xFF13B9FF);

  @override
  Color get accentColor => const Color(0xFF13B9FF);

  @override
  MaterialColor get primarySwatch => Colors.blue;
}

class ThemeStateLight implements ThemeState {
  const ThemeStateLight();
  @override
  Color get backgroundColor => const Color(0xFFFFFFFF);

  @override
  Color get primaryTextColor => const Color(0xFF000000);

  @override
  Color get appBarColor => const Color(0xFF000000);

  @override
  Color get accentColor => const Color(0xFF000000);

  @override
  MaterialColor get primarySwatch => Colors.grey;
}
