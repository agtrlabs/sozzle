import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sozzle/src/settings/cubit/setting_cubit.dart';
import 'package:sozzle/src/settings/domain/i_setting_repository.dart';
import 'package:sozzle/src/settings/domain/settings.dart';
import 'package:sozzle/src/theme/cubit/theme_cubit.dart';

class MockSettingsRepo extends Mock implements ISettingRepository {}

class MockThemeCubit extends MockCubit<ThemeState> implements ThemeCubit {}

class MockSettingCubit extends MockCubit<SettingState>
    implements SettingCubit {}

void main() {
  late SettingCubit cubit;
  late ISettingRepository settingRepository;
  late ThemeCubit themeCubit;

  setUp(() {
    settingRepository = MockSettingsRepo();
    themeCubit = MockThemeCubit();

    cubit = SettingCubit(
      settingRep: settingRepository,
      themeCubit: themeCubit,
    );

    when(
      () => settingRepository.setSoundSetting(
        value: any(named: 'value'),
        cache: any(named: 'cache'),
      ),
    ).thenAnswer(
      (_) async => Future.value(),
    );
    when(
      () => settingRepository.setMusicSetting(
        value: any(named: 'value'),
        cache: any(named: 'cache'),
      ),
    ).thenAnswer(
      (_) async => Future.value(),
    );
    when(
      () => settingRepository.setMuteSetting(value: any(named: 'value')),
    ).thenAnswer(
      (_) async => Future.value(),
    );
    when(
      () => settingRepository.setDarkModeSetting(value: any(named: 'value')),
    ).thenAnswer(
      (_) async => Future.value(),
    );
    when(
      () => settingRepository.getSetting(),
    ).thenAnswer(
      (_) async => const Settings.empty(),
    );
    when(() => themeCubit.getThemeDark())
        .thenAnswer((_) async => Future.value());
    when(() => themeCubit.getThemeDark()).thenAnswer(
      (_) async => Future.value(),
    );
  });

  group(
    'Setting Cubit',
    () {
      test('initial state is [SettingState.initial]', () {
        expect(cubit.state, equals(SettingState.initial()));
      });

      blocTest<SettingCubit, SettingState>(
        'should change isDarkMode to the appropriate toggle value',
        setUp: () {
          WidgetsFlutterBinding.ensureInitialized();
        },
        build: () => cubit,
        act: (bloc) => bloc.toggleDarkModeOption(val: true),
        expect: () => [
          SettingState.initial().copyWith(isDarkMode: true),
        ],
      );

      group(':toggleSoundOption:', () {
        test(
          'should turn off mute when sound is turned on',
          () {
            expect(cubit.state.isMute, true);
            expect(cubit.state.isSoundOn, false);

            cubit.toggleSoundOption(val: true);

            expect(
              cubit.stream.asBroadcastStream(),
              emits(
                SettingState.initial().copyWith(isMute: false, isSoundOn: true),
              ),
            );

            verify(
              () => settingRepository.setSoundSetting(value: true, cache: true),
            ).called(1);
          },
        );
        test(
          'should turn on mute when sound is turned off and music was '
          'already off',
          () async {
            expect(cubit.state.isSoundOn, false);
            expect(cubit.state.isMute, true);
            expect(cubit.state.isMusicOn, false);

            await cubit.toggleSoundOption(val: true);

            expect(cubit.state.isMute, false);

            unawaited(cubit.toggleSoundOption(val: false));

            expect(
              cubit.stream.asBroadcastStream(),
              emits(
                SettingState.initial().copyWith(isMute: true, isSoundOn: false),
              ),
            );
          },
        );
        test(
          'should NOT turn on mute when sound is turned off and music is on',
          () async {
            expect(cubit.state.isSoundOn, false);
            expect(cubit.state.isMute, true);
            expect(cubit.state.isMusicOn, false);

            await cubit.toggleSoundOption(val: true);
            await cubit.toggleMusicOption(val: true);

            expect(cubit.state.isMute, false);
            expect(cubit.state.isMusicOn, true);

            unawaited(cubit.toggleSoundOption(val: false));

            expect(
              cubit.stream.asBroadcastStream(),
              emits(
                SettingState.initial().copyWith(
                  isMute: false,
                  isSoundOn: false,
                  isMusicOn: true,
                ),
              ),
            );
          },
        );
      });
      group(':toggleMusicOption:', () {
        test(
          'should turn off mute when music is turned on',
          () {
            expect(cubit.state.isMute, true);
            expect(cubit.state.isMusicOn, false);

            cubit.toggleMusicOption(val: true);

            expect(
              cubit.stream.asBroadcastStream(),
              emits(
                SettingState.initial().copyWith(isMute: false, isMusicOn: true),
              ),
            );

            verify(
              () => settingRepository.setMusicSetting(value: true, cache: true),
            ).called(1);
          },
        );
        test(
          'should turn on mute when music is turned off and sound was '
          'already off',
          () async {
            expect(cubit.state.isMusicOn, false);
            expect(cubit.state.isMute, true);
            expect(cubit.state.isSoundOn, false);

            await cubit.toggleMusicOption(val: true);

            expect(cubit.state.isMute, false);

            unawaited(cubit.toggleMusicOption(val: false));

            expect(
              cubit.stream.asBroadcastStream(),
              emits(
                SettingState.initial().copyWith(isMute: true, isMusicOn: false),
              ),
            );
          },
        );
        test(
          'should NOT turn on mute when music is turned off and sound is on',
          () async {
            expect(cubit.state.isMusicOn, false);
            expect(cubit.state.isMute, true);
            expect(cubit.state.isSoundOn, false);

            await cubit.toggleMusicOption(val: true);
            await cubit.toggleSoundOption(val: true);

            expect(cubit.state.isMute, false);
            expect(cubit.state.isSoundOn, true);

            unawaited(cubit.toggleMusicOption(val: false));

            expect(
              cubit.stream.asBroadcastStream(),
              emits(
                SettingState.initial().copyWith(
                  isMute: false,
                  isMusicOn: false,
                  isSoundOn: true,
                ),
              ),
            );
          },
        );
      });

      group(':toggleMuteOption:', () {
        test(
          'should turn off sound and music when mute is turned on',
          () async {
            await cubit.toggleMusicOption(val: true);
            await cubit.toggleSoundOption(val: true);

            expect(cubit.state.isMusicOn, true);
            expect(cubit.state.isSoundOn, true);

            unawaited(cubit.toggleMuteOption(val: true));

            expect(
              cubit.stream.asBroadcastStream(),
              emits(
                SettingState.initial().copyWith(
                  isMusicOn: false,
                  isSoundOn: false,
                  isMute: true,
                ),
              ),
            );
            await untilCalled(
              () => settingRepository.setSoundSetting(
                value: any(named: 'value'),
              ),
            );
            await untilCalled(
              () => settingRepository.setMusicSetting(
                value: any(named: 'value'),
              ),
            );
            await untilCalled(
              () => settingRepository.setMuteSetting(
                value: any(named: 'value'),
              ),
            );
            verify(() => settingRepository.setMusicSetting(value: false))
                .called(1);
            verify(() => settingRepository.setSoundSetting(value: false))
                .called(1);
            verify(() => settingRepository.setMuteSetting(value: true))
                .called(1);
          },
        );

        test(
          'should set music and sound to their last known value when '
          'mute is turned off',
          () async {
            when(() => settingRepository.getSetting()).thenAnswer(
              (_) async => const Settings.empty().copyWith(
                isSoundOnCache: true,
              ),
            );
            await cubit.toggleSoundOption(val: true);

            expect(
              cubit.state,
              equals(
                SettingState.initial().copyWith(
                  isSoundOn: true,
                  isMusicOn: false,
                  isMute: false,
                ),
              ),
            );

            await cubit.toggleMuteOption(val: true);

            expect(
              cubit.state,
              equals(
                SettingState.initial().copyWith(
                  isSoundOn: false,
                  isMusicOn: false,
                  isMute: true,
                ),
              ),
            );
            unawaited(cubit.toggleMuteOption(val: false));

            expect(
              cubit.stream.asBroadcastStream(),
              emits(
                SettingState.initial().copyWith(
                  isSoundOn: true,
                  isMusicOn: false,
                  isMute: false,
                ),
              ),
            );
          },
        );
      });
    },
  );
}
