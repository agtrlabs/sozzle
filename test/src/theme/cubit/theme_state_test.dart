import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sozzle/src/theme/cubit/theme_cubit.dart';

void main() {
  group('Test ThemeState getters', () {
    late final ThemeCubit themeCubit;
    setUpAll(() {
      themeCubit = ThemeCubit()..getThemeDark();
    });

    test('get dark theme backgroundColor', () {
      expect(themeCubit.state.backgroundColor, const Color(0xFF123456));
    });

    test('get dark theme primaryTextColor', () {
      expect(themeCubit.state.primaryTextColor, const Color(0xFFEEEEEE));
    });

    test('get dark theme appBarColor', () {
      expect(themeCubit.state.appBarColor, const Color(0xFF13B9FF));
    });

    test('get dark theme accentColor', () {
      expect(themeCubit.state.accentColor, const Color(0xFF13B9FF));
    });

    test('get dark theme primarySwatch', () {
      expect(themeCubit.state.primarySwatch, Colors.blue);
    });
  });
}
