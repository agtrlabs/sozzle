import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sozzle/l10n/l10n.dart';
import 'package:sozzle/src/settings/cubit/setting_cubit.dart';
import 'package:sozzle/src/settings/view/settings_page.dart';
import 'package:sozzle/src/theme/cubit/theme_cubit.dart';

void main() {
  group('Settings Page ', () {
    late SettingCubit settingCubit;
    late ThemeCubit themeCubit;
    late Widget settingsPage;

    setUp(() {
      settingCubit = SettingCubit();
      themeCubit = ThemeCubit();
      settingsPage = MultiBlocProvider(
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
      );
    });

    testWidgets('turn switch on/off', (WidgetTester tester) async {
      await tester.pumpWidget(settingsPage);

      final finderSwitchOff = find.byWidgetPredicate(
        (widget) => widget is Switch && widget.value == false,
        description: 'Switch is disabled',
      );

      expect(finderSwitchOff, findsNWidgets(4));

      settingCubit.toggleMusicOption(val: true);
      await tester.pump();

      final finderSwitchOn = find.byWidgetPredicate(
        (widget) => widget is Switch && widget.value == true,
        description: 'Switch is enabled',
      );
      expect(finderSwitchOn, findsOneWidget);

      settingCubit.toggleMusicOption(val: false);
      await tester.pump();

      expect(finderSwitchOn, findsNothing);
    });

    testWidgets('turn on sound', (WidgetTester tester) async {
      await tester.pumpWidget(settingsPage);

      await tester.tap(find.byKey(const Key('switchSound')));
      await tester.pump();

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
  });
}
