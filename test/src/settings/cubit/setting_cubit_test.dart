import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sozzle/src/settings/cubit/setting_cubit.dart';

void main() {
  group('Setting Cubit', () {
    blocTest<SettingCubit, SettingState>(
      'emits [RandomCatStatus.loading, RandomCatStatus.emptyBreeds] '
      'state when cat.breeds are null',
      setUp: () {
      },
      build: SettingCubit.new,
      act: (bloc) => bloc.toggleDarkModeOption(val: true),
      expect: () => [
        SettingInitial(
          isSoundOn: false,
          isMusicOn: false,
          isDarkMode: true,
          isMute: false,
        ),
      ],
    );

    blocTest<SettingCubit, SettingState>(
      'emits [RandomCatStatus.loading, RandomCatStatus.emptyBreeds] '
      'state when cat.breeds are null',
      setUp: () {},
      build: SettingCubit.new,
      act: (bloc) => bloc
        ..toggleMuteOption(val: true)
        ..toggleMusicOption(
          val: true,
        )
        ..toggleSoundOption(val: true)
        ..toggleDarkModeOption(val: true)
        ..toggleMuteOption(val: false),
      expect: () => [
        SettingInitial(
          isSoundOn: false,
          isMusicOn: false,
          isDarkMode: false,
          isMute: true,
        ),
        SettingInitial(
          isSoundOn: false,
          isMusicOn: true,
          isDarkMode: false,
          isMute: true,
        ),
        SettingInitial(
          isSoundOn: true,
          isMusicOn: true,
          isDarkMode: false,
          isMute: true,
        ),
        SettingInitial(
          isSoundOn: true,
          isMusicOn: true,
          isDarkMode: true,
          isMute: true,
        ),
        SettingInitial(
          isSoundOn: true,
          isMusicOn: true,
          isDarkMode: true,
          isMute: false,
        ),
      ],
    );
  });
}
