import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sozzle/src/apploader/apploader.dart';
import 'package:sozzle/src/settings/cubit/setting_cubit.dart';
import 'package:sozzle/src/splash/splash_page.dart';
import 'package:sozzle/src/theme/cubit/theme_cubit.dart';

import '../../helpers/helpers.dart';

void main() {
  late ApploaderCubit appLoaderCubit;
  late ThemeCubit themeCubit;
  late SettingCubit settingCubit;

  setUp(() {
    appLoaderCubit = MockAppLoaderCubit();
    themeCubit = MockThemeCubit();
    settingCubit = MockSettingsCubit();

    when(() => appLoaderCubit.state).thenReturn(
      const ApploaderState(LoaderState.initial),
    );

    when(() => appLoaderCubit.updatePuzzleData()).thenAnswer(
      (_) async => Future.value(),
    );

    when(() => themeCubit.state).thenReturn(const ThemeStateLight());
    when(() => settingCubit.state).thenReturn(SettingState.initial());
  });

  group('SplashPage', () {
    testWidgets('should render a [SplashPage]', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<ApploaderCubit>.value(value: appLoaderCubit),
            BlocProvider<ThemeCubit>.value(value: themeCubit),
            BlocProvider<SettingCubit>.value(value: settingCubit),
          ],
          child: const SplashPage(),
        ),
      );

      expect(find.byType(SplashPage), findsOneWidget);
    });
    testWidgets(
      'should render the "Sozzle" Text after 3400 milliseconds',
      (tester) async {
        await tester.pumpApp(
          MultiBlocProvider(
            providers: [
              BlocProvider<ApploaderCubit>.value(value: appLoaderCubit),
              BlocProvider<ThemeCubit>.value(value: themeCubit),
              BlocProvider<SettingCubit>.value(value: settingCubit),
            ],
            child: const SplashPage(),
          ),
        );

        await tester.pumpAndSettle(const Duration(milliseconds: 3400));

        expect(find.text('Sozzle'), findsOneWidget);
      },
    );
  });
}
