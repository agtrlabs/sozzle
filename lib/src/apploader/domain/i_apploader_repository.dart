import 'package:sozzle/src/level/domain/i_level_repository.dart';
import 'package:sozzle/src/level/domain/level_data.dart';
import 'package:sozzle/src/user_stats/domain/user_progress_data.dart';
import 'package:sozzle/src/user_stats/user_stats.dart';

/// checks updates, loads updated data, saves to local
abstract class IApploaderRepository {
  IApploaderRepository(this.levelRepository, this.userStatsRepository);
  ILevelRepository levelRepository;
  IUserStatsRepository userStatsRepository;
  Future<LevelList> getLevels();
  Future<UserProgressData> getUserProgressData();
  Stream<double> saveData();
}
