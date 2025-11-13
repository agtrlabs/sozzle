import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:game_core/src/models/game_level.dart';
import 'package:game_core/src/models/user_progress.dart';
import 'package:game_core/src/repositories/game_level_repository.dart';
import 'package:game_core/src/repositories/user_progress_repository.dart';

part 'game_core_event.dart';
part 'game_core_state.dart';

/// The main bloc that orchestrates the game lifecycle.
///
/// This bloc manages:
/// - Loading user progress
/// - Loading and playing levels
/// - Tracking level completion
/// - Managing hints
/// - Persisting progress
class GameCoreBloc extends Bloc<GameCoreEvent, GameCoreState> {
  /// Creates a [GameCoreBloc].
  GameCoreBloc({
    required GameLevelRepository levelRepository,
    required UserProgressRepository progressRepository,
  }) : _levelRepository = levelRepository,
       _progressRepository = progressRepository,
       super(const GameCoreInitial()) {
    on<GameStarted>(_onGameStarted);
    on<PlayLevelRequested>(_onPlayLevelRequested);
    on<LevelCompleted>(_onLevelCompleted);
    on<HintUsed>(_onHintUsed);
    on<GameReset>(_onGameReset);
    on<NextLevelRequested>(_onNextLevelRequested);
    on<ReturnToHomeRequested>(_onReturnToHomeRequested);
  }

  final GameLevelRepository _levelRepository;
  final UserProgressRepository _progressRepository;

  Future<void> _onGameStarted(
    GameStarted event,
    Emitter<GameCoreState> emit,
  ) async {
    try {
      log('GameCore: Starting game', name: 'GameCoreBloc');
      final progress = await _progressRepository.load();
      log(
        'GameCore: Loaded progress - level ${progress.currentLevel}',
        name: 'GameCoreBloc',
      );
      emit(GameCoreIdle(progress: progress));
    } on Exception catch (error, stackTrace) {
      log(
        'GameCore: Error starting game',
        name: 'GameCoreBloc',
        error: error,
        stackTrace: stackTrace,
      );
      emit(
        const GameCoreError(
          progress: UserProgress.initial(),
          message: 'Failed to start game',
        ),
      );
    }
  }

  Future<void> _onPlayLevelRequested(
    PlayLevelRequested event,
    Emitter<GameCoreState> emit,
  ) async {
    try {
      log('GameCore: Loading level ${event.levelId}', name: 'GameCoreBloc');
      emit(
        GameCoreLoadingLevel(
          progress: state.progress,
          levelId: event.levelId,
        ),
      );

      final levelData = await _levelRepository.load(event.levelId);
      final level = GameLevel.fromLevelData(levelData);

      log('GameCore: Level ${event.levelId} loaded', name: 'GameCoreBloc');
      emit(GameCorePlaying(progress: state.progress, level: level));
    } on Exception catch (error, stackTrace) {
      log(
        'GameCore: Error loading level ${event.levelId}',
        name: 'GameCoreBloc',
        error: error,
        stackTrace: stackTrace,
      );
      emit(
        GameCoreError(
          progress: state.progress,
          message: 'Failed to load level ${event.levelId}',
        ),
      );
    }
  }

  Future<void> _onLevelCompleted(
    LevelCompleted event,
    Emitter<GameCoreState> emit,
  ) async {
    if (state is! GameCorePlaying) {
      log(
        'GameCore: LevelCompleted called in wrong state: ${state.runtimeType}',
        name: 'GameCoreBloc',
      );
      return;
    }

    final playingState = state as GameCorePlaying;
    final level = playingState.level;
    final pointsEarned = level.points;

    try {
      log('GameCore: Level ${level.levelId} completed', name: 'GameCoreBloc');

      // Update progress: advance level and add points
      final newProgress = state.progress.copyWith(
        currentLevel: level.levelId < state.progress.currentLevel
            ? state.progress.currentLevel
            : level.levelId + 1,
        points: state.progress.points + pointsEarned,
      );

      // Persist the progress
      await _progressRepository.save(newProgress);

      log(
        'GameCore: Progress saved - level ${newProgress.currentLevel}, '
        'points ${newProgress.points}',
        name: 'GameCoreBloc',
      );

      emit(
        GameCoreLevelWon(
          progress: newProgress,
          level: level,
          pointsEarned: pointsEarned,
        ),
      );
    } on Exception catch (error, stackTrace) {
      log(
        'GameCore: Error completing level',
        name: 'GameCoreBloc',
        error: error,
        stackTrace: stackTrace,
      );
      emit(
        GameCoreError(
          progress: state.progress,
          message: 'Failed to complete level',
        ),
      );
    }
  }

  Future<void> _onHintUsed(
    HintUsed event,
    Emitter<GameCoreState> emit,
  ) async {
    if (state.progress.hintsAvailable <= 0) {
      log('GameCore: No hints available', name: 'GameCoreBloc');
      return;
    }

    try {
      final newProgress = state.progress.copyWith(
        hintsAvailable: state.progress.hintsAvailable - 1,
      );

      await _progressRepository.save(newProgress);

      log(
        'GameCore: Hint used, ${newProgress.hintsAvailable} remaining',
        name: 'GameCoreBloc',
      );

      // Maintain current state but update progress
      if (state is GameCorePlaying) {
        emit(
          GameCorePlaying(
            progress: newProgress,
            level: (state as GameCorePlaying).level,
          ),
        );
      } else if (state is GameCoreIdle) {
        emit(GameCoreIdle(progress: newProgress));
      }
    } on Exception catch (error, stackTrace) {
      log(
        'GameCore: Error using hint',
        name: 'GameCoreBloc',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _onGameReset(
    GameReset event,
    Emitter<GameCoreState> emit,
  ) async {
    try {
      log('GameCore: Resetting game', name: 'GameCoreBloc');
      final progress = await _progressRepository.load();
      emit(GameCoreIdle(progress: progress));
    } on Exception catch (error, stackTrace) {
      log(
        'GameCore: Error resetting game',
        name: 'GameCoreBloc',
        error: error,
        stackTrace: stackTrace,
      );
      emit(
        GameCoreError(
          progress: state.progress,
          message: 'Failed to reset game',
        ),
      );
    }
  }

  Future<void> _onNextLevelRequested(
    NextLevelRequested event,
    Emitter<GameCoreState> emit,
  ) async {
    if (state is! GameCoreLevelWon) {
      log(
        'GameCore: NextLevel called in wrong state: ${state.runtimeType}',
        name: 'GameCoreBloc',
      );
      return;
    }

    final wonState = state as GameCoreLevelWon;
    final nextLevelId = wonState.level.levelId + 1;

    log('GameCore: Requesting next level: $nextLevelId', name: 'GameCoreBloc');
    add(PlayLevelRequested(nextLevelId));
  }

  Future<void> _onReturnToHomeRequested(
    ReturnToHomeRequested event,
    Emitter<GameCoreState> emit,
  ) async {
    log('GameCore: Returning to home', name: 'GameCoreBloc');
    emit(GameCoreIdle(progress: state.progress));
  }
}
