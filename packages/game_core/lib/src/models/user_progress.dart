import 'package:equatable/equatable.dart';

/// Represents the user's progress through the game.
///
/// This model is independent of storage implementation details
/// and focuses on the domain representation of user progress.
class UserProgress extends Equatable {
  /// Creates a [UserProgress] instance.
  const UserProgress({
    required this.currentLevel,
    this.points = 0,
    this.hintsAvailable = 0,
  });

  /// Creates an initial [UserProgress] for a new user.
  const UserProgress.initial()
    : currentLevel = 1,
      points = 0,
      hintsAvailable = 0;

  /// The current level the user is on.
  final int currentLevel;

  /// The total points the user has earned.
  final int points;

  /// The number of hints available to the user.
  final int hintsAvailable;

  /// Creates a copy of this [UserProgress] with the given fields replaced.
  UserProgress copyWith({
    int? currentLevel,
    int? points,
    int? hintsAvailable,
  }) {
    return UserProgress(
      currentLevel: currentLevel ?? this.currentLevel,
      points: points ?? this.points,
      hintsAvailable: hintsAvailable ?? this.hintsAvailable,
    );
  }

  @override
  List<Object?> get props => [currentLevel, points, hintsAvailable];
}
