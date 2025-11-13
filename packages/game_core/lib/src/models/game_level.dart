import 'package:equatable/equatable.dart';
import 'package:level_data/level_data.dart';

/// Represents a game level in the domain.
///
/// This wraps [LevelData] from the level_data package and provides
/// domain-specific behavior and properties.
class GameLevel extends Equatable {
  /// Creates a [GameLevel] from [LevelData].
  const GameLevel({
    required this.levelId,
    required this.data,
  });

  /// Creates a [GameLevel] from [LevelData].
  factory GameLevel.fromLevelData(LevelData data) {
    return GameLevel(
      levelId: data.levelId,
      data: data,
    );
  }

  /// The unique identifier for this level.
  final int levelId;

  /// The underlying level data.
  final LevelData data;

  /// The total number of words in this level.
  int get totalWords => data.words.length;

  /// The points awarded for completing this level.
  int get points => LevelData.levelPoint;

  @override
  List<Object?> get props => [levelId, data];
}
