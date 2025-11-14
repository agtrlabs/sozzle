part of 'game_core_bloc.dart';

/// Base class for all GameCore events.
sealed class GameCoreEvent extends Equatable {
  const GameCoreEvent();

  @override
  List<Object?> get props => [];
}

/// Event to start the game and load initial state.
final class GameStarted extends GameCoreEvent {
  /// Event to start the game and load initial state.
  const GameStarted();
}

/// Event to request playing a specific level.
final class PlayLevelRequested extends GameCoreEvent {
  /// Event to request playing a specific level.
  const PlayLevelRequested(this.levelId);

  /// The ID of the level to play.
  final int levelId;

  @override
  List<Object?> get props => [levelId];
}

/// Event to mark the current level as completed.
final class LevelCompleted extends GameCoreEvent {
  /// Event to mark the current level as completed.
  const LevelCompleted();
}

/// Event to use a hint in the current level.
final class HintUsed extends GameCoreEvent {
  /// Event to use a hint in the current level.
  const HintUsed();
}

/// Event to reset the game and return to home/idle state.
final class GameReset extends GameCoreEvent {
  /// Event to reset the game and return to home/idle state.
  const GameReset();
}

/// Event to advance to the next level after completing current one.
final class NextLevelRequested extends GameCoreEvent {
  /// Event to advance to the next level after completing current one.
  const NextLevelRequested();
}

/// Event to return to home from level won state.
final class ReturnToHomeRequested extends GameCoreEvent {
  /// Event to return to home from level won state.
  const ReturnToHomeRequested();
}
