import 'package:game_core/src/models/user_progress.dart';

/// Repository interface for loading and saving user progress.
///
/// This abstraction allows GameCore to persist user progress without
/// depending on specific storage implementations.
abstract class UserProgressRepository {
  /// Loads the current user progress.
  ///
  /// Returns a new [UserProgress] if no saved progress exists.
  Future<UserProgress> load();

  /// Saves the user progress.
  Future<void> save(UserProgress progress);
}
