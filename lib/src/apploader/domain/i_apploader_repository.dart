// coverage:ignore-file
import 'package:sozzle/src/level/domain/i_level_repository.dart';
import 'package:sozzle/src/level/domain/level_data.dart';
import 'package:sozzle/src/settings/domain/i_setting_repository.dart';
import 'package:sozzle/src/settings/domain/settings.dart';
import 'package:sozzle/src/user_stats/user_stats.dart';

/// checks updates, loads updated data, saves to local
abstract class IApploaderRepository {
  IApploaderRepository(
    this.levelRepository,
    this.userStatsRepository,
    this.settingRepository,
  );
  ILevelRepository levelRepository;
  IUserStatsRepository userStatsRepository;
  ISettingRepository settingRepository;
  Future<Settings> getSetting();
  Future<LevelList> getLevels();
  Future<UserProgressData> getUserProgressData();
  Stream<double> saveData({bool writeToDisk = true});
}
