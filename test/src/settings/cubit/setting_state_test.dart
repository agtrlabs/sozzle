import 'package:flutter_test/flutter_test.dart';
import 'package:sozzle/src/settings/cubit/setting_cubit.dart';

void main() {
  group('Settings Cubit', () {
    late SettingInitial settingInitial;
    setUp(() {
      settingInitial = SettingInitial(
        isSoundOn: false,
        isMusicOn: false,
        isDarkMode: false,
        isMute: false,
      );
    });

    test('initial state is correct', () {
      expect(
        SettingCubit().state,
        settingInitial,
      );
    });

    test('copyWith is working', () {
      expect(
        settingInitial.copyWith(
          isMusicOn: true,
          isSoundOn: true,
          isDarkMode: true,
          isMute: true,
        ),
        SettingInitial(
          isSoundOn: true,
          isMusicOn: true,
          isDarkMode: true,
          isMute: true,
        ),
      );
    });

    test('copyWith with one property change', () {
      expect(
        settingInitial.copyWith(
          isMusicOn: true,
        ),
        SettingInitial(
          isSoundOn: false,
          isMusicOn: true,
          isDarkMode: false,
          isMute: false,
        ),
      );
    });
  });
}
