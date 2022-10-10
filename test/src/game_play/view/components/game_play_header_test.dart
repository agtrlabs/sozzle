import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sozzle/src/game_play/view/components/game_play_header.dart';
import 'package:sozzle/src/theme/theme.dart';
import 'package:sozzle/src/user_stats/cubit/user_stats_cubit.dart';
import '../../../../helpers/helpers.dart';

class MockUserStatsCubit extends MockCubit<UserStatsState>
    implements UserStatsCubit {}

class MockThemeCubit extends MockCubit<ThemeState> implements ThemeCubit {}

void main() {
  group('GamePlayHeader', () {
    late MockUserStatsCubit userStatsCubit;
    late UserStatsState userStatsState;
    late MockThemeCubit themeCubit;
    setUp(() {
      userStatsCubit = MockUserStatsCubit();
      userStatsState = UserStatsState.initial();
      themeCubit = MockThemeCubit();
      whenListen<UserStatsState>(
        userStatsCubit,
        Stream.value(userStatsState),
        initialState: userStatsState,
      );
      whenListen<ThemeState>(
        themeCubit,
        Stream.value(const ThemeStateDark()),
        initialState: const ThemeStateDark(),
      );
    });
    testWidgets('should display current level', (WidgetTester tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<UserStatsCubit>(
              create: (context) => userStatsCubit,
            ),
            BlocProvider<ThemeCubit>(
              create: (context) => themeCubit,
            ),
          ],
          child: const GamePlayHeader(),
        ),
      );
      await tester.pump();
      final futureFinder =
          find.text('Level ${userStatsState.progress.currentLevel}');
      await tester.pump();
      expect(futureFinder, findsOneWidget);
    });
    testWidgets('should display current level', (WidgetTester tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<UserStatsCubit>(
              create: (context) => userStatsCubit,
            ),
            BlocProvider<ThemeCubit>(
              create: (context) => themeCubit,
            ),
          ],
          child: const GamePlayHeader(),
        ),
      );
      await tester.pump();
      final futureFinder =
          find.text('Level ${userStatsState.progress.currentLevel}');
      await tester.pump();
      expect(futureFinder, findsOneWidget);
    });
  });
}
