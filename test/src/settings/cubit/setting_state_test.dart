import 'package:flutter_test/flutter_test.dart';
import 'package:sozzle/src/settings/cubit/setting_cubit.dart';

void main() {
  group('Settings Cubit', () {
    late SettingState settingInitial;
    setUp(() {
      settingInitial = SettingState.initial();
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
        const SettingState(
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
        const SettingState(
          isSoundOn: false,
          isMusicOn: true,
          isDarkMode: false,
          isMute: false,
        ),
      );
    });
  });
}
