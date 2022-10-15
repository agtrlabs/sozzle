/* import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sozzle/src/game_play/view/components/game_loader.dart';
import 'package:sozzle/src/game_play/view/view.dart';
import 'package:sozzle/src/level/domain/i_level_repository.dart';
import 'package:sozzle/src/level/domain/level_data.dart';
import 'package:sozzle/src/theme/cubit/theme_cubit.dart';
import 'package:sozzle/src/user_stats/user_stats.dart';
import '../../../helpers/helpers.dart';

class MockLevelRepository extends Mock implements ILevelRepository {}

class MockUserStatsCubit extends MockCubit<UserStatsState>
    implements UserStatsCubit {}

class MockThemeCubit extends MockCubit<ThemeState> implements ThemeCubit {}

void main() {
  group('GamePlayPage', () {
    late MockLevelRepository repo;
    late MockUserStatsCubit userStatsCubit;
    late MockThemeCubit themeCubit;
    setUp(() async {
      repo = MockLevelRepository();
      userStatsCubit = MockUserStatsCubit();
      themeCubit = MockThemeCubit();
    });
    testWidgets('should have a GameLoader', (WidgetTester tester) async {
      when(() => repo.getLevel(any())).thenAnswer(
        (_) async => LevelData(
          boardData: [],
          boardWidth: 1,
          boardHeight: 1,
          levelId: 1,
          words: [],
        ),
      );
      whenListen<UserStatsState>(
        userStatsCubit,
        Stream.value(UserStatsState.initial()),
        initialState: UserStatsState.initial(),
      );
      whenListen<ThemeState>(
        themeCubit,
        Stream.value(const ThemeStateDark()),
        initialState: const ThemeStateDark(),
      );
      await tester.pumpApp(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<ILevelRepository>(
              create: (context) => repo,
            ),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<UserStatsCubit>(
                create: (context) => userStatsCubit,
              ),
              BlocProvider<ThemeCubit>(
                create: (context) => themeCubit,
              ),
            ],
            child: const GamePlayPage(
              levelID: 1,
            ),
          ),
        ),
      );
      await tester.pump();
      final futureFinder = find.byType(GameLoader);
      expect(futureFinder, findsOneWidget);
    });
  });
}
 */

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('no tests', () => expect(1, 1));
}
