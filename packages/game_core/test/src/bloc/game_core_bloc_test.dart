import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:game_core/game_core.dart';
import 'package:level_data/level_data.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockGameLevelRepository extends Mock implements GameLevelRepository {}

class MockUserProgressRepository extends Mock
    implements UserProgressRepository {}

void main() {
  group('GameCoreBloc', () {
    late GameLevelRepository levelRepository;
    late UserProgressRepository progressRepository;

    const testProgress = UserProgress(currentLevel: 1);
    const testLevelData = LevelData(
      levelId: 1,
      words: ['TEST', 'WORD'],
      boardWidth: 5,
      boardHeight: 5,
      boardData: ['T', 'E', 'S', 'T', ' '],
      crosswords: {},
    );

    setUpAll(() {
      registerFallbackValue(testProgress);
      registerFallbackValue(testLevelData);
    });

    setUp(() {
      levelRepository = MockGameLevelRepository();
      progressRepository = MockUserProgressRepository();
    });

    test('initial state is GameCoreInitial', () {
      final bloc = GameCoreBloc(
        levelRepository: levelRepository,
        progressRepository: progressRepository,
      );

      expect(bloc.state, isA<GameCoreInitial>());
      unawaited(bloc.close());
    });

    blocTest<GameCoreBloc, GameCoreState>(
      'emits [GameCoreIdle] when GameStarted is added',
      build: () {
        when(
          () => progressRepository.load(),
        ).thenAnswer((_) async => testProgress);
        return GameCoreBloc(
          levelRepository: levelRepository,
          progressRepository: progressRepository,
        );
      },
      act: (bloc) => bloc.add(const GameStarted()),
      expect: () => [
        const GameCoreIdle(progress: testProgress),
      ],
      verify: (_) {
        verify(() => progressRepository.load()).called(1);
      },
    );

    blocTest<GameCoreBloc, GameCoreState>(
      'emits [GameCoreError] when GameStarted fails',
      build: () {
        when(() => progressRepository.load()).thenThrow(Exception('Failed'));
        return GameCoreBloc(
          levelRepository: levelRepository,
          progressRepository: progressRepository,
        );
      },
      act: (bloc) => bloc.add(const GameStarted()),
      expect: () => [
        isA<GameCoreError>().having(
          (s) => s.message,
          'message',
          'Failed to start game',
        ),
      ],
    );

    blocTest<GameCoreBloc, GameCoreState>(
      'emits [GameCoreLoadingLevel, GameCorePlaying] '
      'when PlayLevelRequested is added',
      build: () {
        when(
          () => levelRepository.load(1),
        ).thenAnswer((_) async => testLevelData);
        return GameCoreBloc(
          levelRepository: levelRepository,
          progressRepository: progressRepository,
        );
      },
      act: (bloc) => bloc.add(const PlayLevelRequested(1)),
      expect: () => [
        const GameCoreLoadingLevel(
          progress: UserProgress.initial(),
          levelId: 1,
        ),
        isA<GameCorePlaying>().having(
          (s) => s.level.levelId,
          'level.levelId',
          1,
        ),
      ],
      verify: (_) {
        verify(() => levelRepository.load(1)).called(1);
      },
    );

    blocTest<GameCoreBloc, GameCoreState>(
      'emits [GameCoreError] when PlayLevelRequested fails',
      build: () {
        when(() => levelRepository.load(1)).thenThrow(Exception('Failed'));
        return GameCoreBloc(
          levelRepository: levelRepository,
          progressRepository: progressRepository,
        );
      },
      act: (bloc) => bloc.add(const PlayLevelRequested(1)),
      expect: () => [
        const GameCoreLoadingLevel(
          progress: UserProgress.initial(),
          levelId: 1,
        ),
        isA<GameCoreError>().having(
          (s) => s.message,
          'message',
          'Failed to load level 1',
        ),
      ],
    );

    blocTest<GameCoreBloc, GameCoreState>(
      'emits [GameCoreLevelWon] when LevelCompleted is added',
      build: () {
        when(() => progressRepository.save(any())).thenAnswer((_) async {});
        return GameCoreBloc(
          levelRepository: levelRepository,
          progressRepository: progressRepository,
        );
      },
      seed: () => GameCorePlaying(
        progress: testProgress,
        level: GameLevel.fromLevelData(testLevelData),
      ),
      act: (bloc) => bloc.add(const LevelCompleted()),
      expect: () => [
        isA<GameCoreLevelWon>()
            .having((s) => s.level.levelId, 'level.levelId', 1)
            .having((s) => s.pointsEarned, 'pointsEarned', LevelData.levelPoint)
            .having(
              (s) => s.progress.currentLevel,
              'progress.currentLevel',
              2,
            )
            .having(
              (s) => s.progress.points,
              'progress.points',
              LevelData.levelPoint,
            ),
      ],
      verify: (_) {
        verify(() => progressRepository.save(any())).called(1);
      },
    );

    blocTest<GameCoreBloc, GameCoreState>(
      'does not emit when LevelCompleted is added in wrong state',
      build: () => GameCoreBloc(
        levelRepository: levelRepository,
        progressRepository: progressRepository,
      ),
      seed: () => const GameCoreIdle(progress: testProgress),
      act: (bloc) => bloc.add(const LevelCompleted()),
      expect: () => <dynamic>[],
    );

    blocTest<GameCoreBloc, GameCoreState>(
      'updates hints when HintUsed is added',
      build: () {
        when(() => progressRepository.save(any())).thenAnswer((_) async {});
        return GameCoreBloc(
          levelRepository: levelRepository,
          progressRepository: progressRepository,
        );
      },
      seed: () => GameCorePlaying(
        progress: testProgress.copyWith(hintsAvailable: 3),
        level: GameLevel.fromLevelData(testLevelData),
      ),
      act: (bloc) => bloc.add(const HintUsed()),
      expect: () => [
        isA<GameCorePlaying>()
            .having(
              (s) => s.progress.hintsAvailable,
              'progress.hintsAvailable',
              2,
            )
            .having((s) => s.level.levelId, 'level.levelId', 1),
      ],
      verify: (_) {
        verify(() => progressRepository.save(any())).called(1);
      },
    );

    blocTest<GameCoreBloc, GameCoreState>(
      'does not update when HintUsed with no hints available',
      build: () => GameCoreBloc(
        levelRepository: levelRepository,
        progressRepository: progressRepository,
      ),
      seed: () => GameCorePlaying(
        progress: testProgress.copyWith(hintsAvailable: 0),
        level: GameLevel.fromLevelData(testLevelData),
      ),
      act: (bloc) => bloc.add(const HintUsed()),
      expect: () => <dynamic>[],
    );

    blocTest<GameCoreBloc, GameCoreState>(
      'emits [GameCoreIdle] when GameReset is added',
      build: () {
        when(
          () => progressRepository.load(),
        ).thenAnswer((_) async => testProgress);
        return GameCoreBloc(
          levelRepository: levelRepository,
          progressRepository: progressRepository,
        );
      },
      seed: () => GameCorePlaying(
        progress: testProgress,
        level: GameLevel.fromLevelData(testLevelData),
      ),
      act: (bloc) => bloc.add(const GameReset()),
      expect: () => [
        const GameCoreIdle(progress: testProgress),
      ],
      verify: (_) {
        verify(() => progressRepository.load()).called(1);
      },
    );

    blocTest<GameCoreBloc, GameCoreState>(
      'requests next level when NextLevelRequested is added',
      build: () {
        when(
          () => levelRepository.load(2),
        ).thenAnswer((_) async => testLevelData.copyWith(levelId: 2));
        return GameCoreBloc(
          levelRepository: levelRepository,
          progressRepository: progressRepository,
        );
      },
      seed: () => GameCoreLevelWon(
        progress: testProgress.copyWith(currentLevel: 2),
        level: GameLevel.fromLevelData(testLevelData),
        pointsEarned: LevelData.levelPoint,
      ),
      act: (bloc) => bloc.add(const NextLevelRequested()),
      expect: () => [
        isA<GameCoreLoadingLevel>().having((s) => s.levelId, 'levelId', 2),
        isA<GameCorePlaying>().having(
          (s) => s.level.levelId,
          'level.levelId',
          2,
        ),
      ],
      verify: (_) {
        verify(() => levelRepository.load(2)).called(1);
      },
    );

    blocTest<GameCoreBloc, GameCoreState>(
      'emits [GameCoreIdle] when ReturnToHomeRequested is added',
      build: () => GameCoreBloc(
        levelRepository: levelRepository,
        progressRepository: progressRepository,
      ),
      seed: () => GameCoreLevelWon(
        progress: testProgress,
        level: GameLevel.fromLevelData(testLevelData),
        pointsEarned: LevelData.levelPoint,
      ),
      act: (bloc) => bloc.add(const ReturnToHomeRequested()),
      expect: () => [
        const GameCoreIdle(progress: testProgress),
      ],
    );
  });
}
