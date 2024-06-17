import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sozzle/src/home/home.dart';
import 'package:sozzle/src/theme/cubit/theme_cubit.dart';
import 'package:sozzle/src/user_stats/cubit/user_stats_cubit.dart';

import '../../../helpers/helpers.dart';

class MockThemeCubit extends MockCubit<ThemeState> implements ThemeCubit {}

class MockUserStatsCubit extends MockCubit<UserStatsState>
    implements UserStatsCubit {}

void main() {
  late ThemeCubit themeCubit;
  late UserStatsCubit userStatsCubit;

  setUp(() {
    themeCubit = MockThemeCubit();
    userStatsCubit = MockUserStatsCubit();
    when(() => themeCubit.state).thenReturn(const ThemeStateLight());
    when(() => userStatsCubit.state).thenReturn(UserStatsState.initial());
  });

  testWidgets(
    'should render [HomePage]',
    (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<ThemeCubit>.value(value: themeCubit),
            BlocProvider<UserStatsCubit>(
              create: (context) => userStatsCubit,
            ),
          ],
          child: const HomePage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
      expect(find.text('Sozzle Home Page'), findsOneWidget);
    },
  );
}
