import 'package:level_data/level_data.dart';

/// Repository interface for loading and saving game levels.
///
/// This abstraction allows GameCore to access level data without
/// depending on specific storage implementations.
abstract class GameLevelRepository {
  /// Loads a level by its ID.
  ///
  /// Throws an exception if the level cannot be loaded.
  Future<LevelData> load(int levelId);

  /// Saves a level.
  ///
  /// This is optional and may be used for caching or level generation.
  Future<void> save(LevelData level);
}
