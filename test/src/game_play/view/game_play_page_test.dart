import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:level_data/level_data.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sozzle/src/audio/domain/i_audio_controller.dart';
import 'package:sozzle/src/game_play/view/components/game_loader.dart';
import 'package:sozzle/src/game_play/view/view.dart';
import 'package:sozzle/src/level/domain/i_level_repository.dart';
import 'package:sozzle/src/theme/cubit/theme_cubit.dart';
import 'package:sozzle/src/user_stats/user_stats.dart';

import '../../../helpers/helpers.dart';

class MockLevelRepository extends Mock implements ILevelRepository {}

class MockAudio extends Mock implements IAudioController {}

class MockUserStatsCubit extends MockCubit<UserStatsState>
    implements UserStatsCubit {}

class MockThemeCubit extends MockCubit<ThemeState> implements ThemeCubit {}

class MockStorage extends Mock implements Storage {}

void main() {
  late Storage storage;

  setUp(() {
    storage = MockStorage();
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
    HydratedBloc.storage = storage;
  });

  group('GamePlayPage', () {
    late MockLevelRepository repo;
    late MockUserStatsCubit userStatsCubit;
    late MockThemeCubit themeCubit;
    late MockAudio audio;
    setUp(() async {
      repo = MockLevelRepository();
      userStatsCubit = MockUserStatsCubit();
      themeCubit = MockThemeCubit();
      audio = MockAudio();
    });

    testWidgets('should have a GameLoader', (WidgetTester tester) async {
      when(() => repo.getLevel(any())).thenAnswer(
        (_) async => const LevelData(
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
            RepositoryProvider<IAudioController>(
              create: (context) => audio,
            ),
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
      await tester.pumpAndSettle(const Duration(seconds: 10));
      final futureFinder = find.byType(GameLoader);
      expect(futureFinder, findsOneWidget);
    });
  });
}
