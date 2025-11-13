part of 'game_core_bloc.dart';

/// Base class for all GameCore states.
sealed class GameCoreState extends Equatable {
  const GameCoreState({
    required this.progress,
  });

  /// The current user progress.
  final UserProgress progress;

  @override
  List<Object?> get props => [progress];
}

/// Initial state before the game has started.
final class GameCoreInitial extends GameCoreState {
  /// Initial state before the game has started.
  const GameCoreInitial() : super(progress: const UserProgress.initial());
}

/// The game is idle, ready for the user to select a level.
final class GameCoreIdle extends GameCoreState {
  /// The game is idle, ready for the user to select a level.
  const GameCoreIdle({required super.progress});

  @override
  List<Object?> get props => [progress];
}

/// A level is being loaded.
final class GameCoreLoadingLevel extends GameCoreState {
  /// A level is being loaded.
  const GameCoreLoadingLevel({required super.progress, required this.levelId});

  /// The ID of the level being loaded.
  final int levelId;

  @override
  List<Object?> get props => [progress, levelId];
}

/// A level is currently being played.
final class GameCorePlaying extends GameCoreState {
  /// A level is currently being played.
  const GameCorePlaying({required super.progress, required this.level});

  /// The level currently being played.
  final GameLevel level;

  @override
  List<Object?> get props => [progress, level];
}

/// The current level has been won.
final class GameCoreLevelWon extends GameCoreState {
  /// The current level has been won.
  const GameCoreLevelWon({
    required super.progress,
    required this.level,
    required this.pointsEarned,
  });

  /// The level that was completed.
  final GameLevel level;

  /// The points earned from completing the level.
  final int pointsEarned;

  @override
  List<Object?> get props => [progress, level, pointsEarned];
}

/// An error occurred in the game core.
final class GameCoreError extends GameCoreState {
  /// An error occurred in the game core.
  const GameCoreError({required super.progress, required this.message});

  /// A human-readable error message.
  final String message;

  @override
  List<Object?> get props => [progress, message];
}
