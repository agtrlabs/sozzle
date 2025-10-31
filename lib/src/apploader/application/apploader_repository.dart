//import 'package:http/http.dart' as http;
import 'package:sozzle/src/apploader/apploader.dart';
import 'package:sozzle/src/level/domain/i_level_repository.dart';
import 'package:sozzle/src/level/domain/level_data.dart';
import 'package:sozzle/src/settings/domain/i_setting_repository.dart';
import 'package:sozzle/src/settings/domain/settings.dart';
import 'package:sozzle/src/user_stats/domain/i_user_stats_repository.dart';
import 'package:sozzle/src/user_stats/domain/user_progress_data.dart';

class MockApploaderRepository implements IApploaderRepository {
  MockApploaderRepository({
    required this.levelRepository,
    required this.userStatsRepository,
    required this.settingRepository,
  });

  LevelList list = LevelList([]);

  @override
  ISettingRepository settingRepository;

  @override
  ILevelRepository levelRepository;

  @override
  Future<LevelList> getLevels() async {
    final levels = await levelRepository.getLevels();
    list.levels.addAll(levels);
    return list;
  }

  @override
  Future<UserProgressData> getUserProgressData() async {
    return userStatsRepository.getCurrent();
  }

  @override
  Stream<double> saveData() async* {
    /// progress percent
    var progress = 0.0;
    yield progress;
    final increment = (1 / list.levels.length) * 100;

    for (final level in list.levels) {
      await levelRepository.setLevel(level);
      //update percent
      progress += increment;
      //level save to file
      // yield progress < 1 ? progress : 0.99;
      yield progress < 100 ? progress : 99;
      // await Future<void>.delayed(const Duration(milliseconds: 200));
    }

    yield 1;
  }

  @override
  IUserStatsRepository userStatsRepository;

  @override
  Future<Settings> getSetting() {
    return settingRepository.getSetting();
  }
}
