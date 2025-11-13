import 'package:game_core/game_core.dart';
import 'package:sozzle/src/game_play/domain/entities/booster.dart';
import 'package:sozzle/src/user_stats/domain/i_user_stats_repository.dart';
import 'package:sozzle/src/user_stats/domain/user_progress_data.dart';

/// Adapter that implements [UserProgressRepository] by delegating to
/// the existing [IUserStatsRepository].
///
/// This adapter translates between GameCore's [UserProgress] domain model
/// and the app's [UserProgressData] storage model.
class UserProgressRepositoryAdapter implements UserProgressRepository {
  /// Creates a [UserProgressRepositoryAdapter].
  const UserProgressRepositoryAdapter({
    required IUserStatsRepository userStatsRepository,
  }) : _userStatsRepository = userStatsRepository;

  final IUserStatsRepository _userStatsRepository;

  @override
  Future<UserProgress> load() async {
    final progressData = await _userStatsRepository.getCurrent();
    return _fromProgressData(progressData);
  }

  @override
  Future<void> save(UserProgress progress) async {
    // Load the current progress data to preserve boosters
    final currentProgressData = await _userStatsRepository.getCurrent();

    // Create updated progress data, preserving boosters
    // and updating current level and points
    final updatedProgressData = currentProgressData.copyWith(
      currentLevel: progress.currentLevel,
      points: progress.points,
    );

    await _userStatsRepository.save(updatedProgressData);
  }

  /// Converts [UserProgressData] to [UserProgress].
  UserProgress _fromProgressData(UserProgressData data) {
    // Count available hints from boosters
    final hintsAvailable = data.boosters
        .whereType<UseAHint>()
        .fold<int>(0, (sum, booster) => sum + booster.boosterCount);

    return UserProgress(
      currentLevel: data.currentLevel,
      points: data.points,
      hintsAvailable: hintsAvailable,
    );
  }
}
