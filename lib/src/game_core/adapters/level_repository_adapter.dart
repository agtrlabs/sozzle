import 'package:game_core/game_core.dart';
import 'package:level_data/level_data.dart';
import 'package:sozzle/src/level/domain/i_level_repository.dart';

/// Adapter that implements [GameLevelRepository] by delegating to
/// the existing [ILevelRepository].
///
/// This allows GameCore to use the existing level repository
/// implementation without tight coupling.
class LevelRepositoryAdapter implements GameLevelRepository {
  /// Creates a [LevelRepositoryAdapter].
  const LevelRepositoryAdapter({
    required ILevelRepository levelRepository,
  }) : _levelRepository = levelRepository;

  final ILevelRepository _levelRepository;

  @override
  Future<LevelData> load(int levelId) {
    return _levelRepository.getLevel(levelId);
  }

  @override
  Future<void> save(LevelData level) {
    return _levelRepository.setLevel(level);
  }
}
