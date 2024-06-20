import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sozzle/l10n/l10n.dart';
import 'package:sozzle/src/settings/application/setting_repository.dart';
import 'package:sozzle/src/settings/cubit/setting_cubit.dart';
import 'package:sozzle/src/settings/domain/i_setting_repository.dart';
import 'package:sozzle/src/settings/view/settings_page.dart';
import 'package:sozzle/src/theme/cubit/theme_cubit.dart';

class MockSettignsRepo extends Mock implements ISettingRepository {}

void main() {
  group('Settings Page ', () {
    late SettingCubit settingCubit;
    late ThemeCubit themeCubit;
    late Widget settingsPage;
    late MockSettignsRepo mockSettignsRepo;

    setUp(() {
      mockSettignsRepo = MockSettignsRepo();

      when(
        () => mockSettignsRepo.setSoundSetting(
          value: any(named: 'value'),
          cache: any(named: 'cache'),
        ),
      ).thenAnswer((_) async {});
      when(() => mockSettignsRepo.setMuteSetting(value: any(named: 'value')))
          .thenAnswer((_) async {});
      when(
        () => mockSettignsRepo.setMusicSetting(
          value: any(named: 'value'),
          cache: any(named: 'cache'),
        ),
      ).thenAnswer((_) async {});
      themeCubit = ThemeCubit(isDarkMode: Future.value(false));
      settingCubit =
          SettingCubit(settingRep: mockSettignsRepo, themeCubit: themeCubit);
      settingsPage = RepositoryProvider<ISettingRepository>(
        create: (context) => SettingRepository(),
        child: MultiBlocProvider(
          providers: [
            BlocProvider<ThemeCubit>(
              create: (context) => themeCubit,
            ),
            BlocProvider<SettingCubit>(
              create: (context) => settingCubit,
            ),
          ],
          child: const MaterialApp(
            home: SettingsPage(),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        ),
      );
    });

    testWidgets(
      'should render [SettingsPage]',
      (tester) async {
        await tester.pumpWidget(settingsPage);

        expect(find.byType(SettingsPage), findsOneWidget);
      },
    );

    testWidgets('turn switch on/off', (WidgetTester tester) async {
      await tester.pumpWidget(settingsPage);

      final finderSwitchOff = find.byWidgetPredicate(
        (widget) => widget is Switch && !widget.value,
        description: 'Switch is disabled',
      );

      expect(finderSwitchOff, findsNWidgets(3));

      await settingCubit.toggleMusicOption(val: true);
      await tester.pumpAndSettle();

      final finderSwitchOn = find.byWidgetPredicate(
        (widget) => widget is Switch && widget.value,
        description: 'Switch is enabled',
      );
      expect(finderSwitchOn, findsOneWidget);

      await settingCubit.toggleMusicOption(val: false);
      await tester.pumpAndSettle();
      // We expect that mute will be turned on here because if music is
      // turned off and sound is turned off then mute automatically goes on
      expect(finderSwitchOn, findsOneWidget);
    });

    testWidgets('turn on sound', (WidgetTester tester) async {
      await tester.pumpWidget(settingsPage);

      await tester.tap(find.byKey(const Key('switchSound')));
      await tester.pumpAndSettle();

      expect(
        settingCubit.state,
        const SettingState(
          isSoundOn: true,
          isMusicOn: false,
          isDarkMode: false,
          isMute: false,
        ),
      );
      expect(find.widgetWithIcon(ListTile, Icons.music_note), findsOneWidget);
    });
    testWidgets('turn on music', (WidgetTester tester) async {
      await tester.pumpWidget(settingsPage);

      await tester.tap(find.byKey(const Key('switchMusic')));
      await tester.pumpAndSettle();

      expect(
        settingCubit.state,
        const SettingState(
          isSoundOn: false,
          isMusicOn: true,
          isDarkMode: false,
          isMute: false,
        ),
      );
      expect(find.widgetWithIcon(ListTile, Icons.music_note), findsOneWidget);
    });
  });
}
