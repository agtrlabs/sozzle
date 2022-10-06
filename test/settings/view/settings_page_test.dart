import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sozzle/src/settings/cubit/setting_cubit.dart';
import 'package:sozzle/src/settings/view/settings_page.dart';
import 'package:sozzle/src/theme/cubit/theme_cubit.dart';

class MockSettingCubit extends MockCubit<SettingState>
    implements SettingCubit {}

class SettingStateFake extends Fake implements SettingState {}

class MockThemeCubit extends MockCubit<ThemeState> implements ThemeCubit {}

class ThemeStateFake extends Fake implements ThemeState {}

void main() {
  group('Settings Page ', () {
    late MockSettingCubit mockSettingCubit;
    late MockThemeCubit mockThemeCubit;

    setUpAll(() {
      registerFallbackValue(
        SettingStateFake(),
      );
      registerFallbackValue(
        ThemeStateFake(),
      );
    });

    setUp(() {
      mockSettingCubit = MockSettingCubit();
      mockThemeCubit = MockThemeCubit();
    });

    testWidgets('renders settings page', (WidgetTester tester) async {
      final settingsPage = MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>(
            create: (context) => ThemeCubit(),
          ),
          BlocProvider<SettingCubit>(
            create: (context) => SettingCubit(),
          ),
        ],
        child: const MaterialApp(
          home: SettingsPage(),
        ),
      );

      await tester.pumpWidget(settingsPage);

      expect(find.widgetWithIcon(ListTile, Icons.music_note), findsOneWidget);
    });
  });
}
