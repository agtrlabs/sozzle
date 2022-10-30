//import 'package:http/http.dart' as http;
import 'package:level_data/level_data.dart';
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
    // TODO(akyunus): get data online
    list.levels.addAll([
      const LevelData(
        levelId: 1,
        words: [
          'RIFLE',
          'FLIRT',
          'FIRE',
          'LEFT',
          'TIRE',
          'REFIT',
          'FILTER',
          'RELIT',
          'TIER',
        ],
        boardHeight: 9,
        boardWidth: 8,
/*
  REFIT 
R   I   
I F R   
FILTER  
L I     
E RELIT 
  T E I 
    F R 
    TIER
*/
        boardData: [
          '',
          'R',
          'I',
          'F',
          'L',
          'E',
          '',
          '',
          '',
          '',
          '',
          '',
          'I',
          '',
          '',
          '',
          '',
          '',
          'R',
          '',
          'F',
          'L',
          'I',
          'R',
          'T',
          '',
          '',
          'E',
          '',
          '',
          'T',
          '',
          'E',
          '',
          '',
          '',
          'F',
          'I',
          'R',
          'E',
          '',
          'L',
          'E',
          'F',
          'T',
          'I',
          '',
          '',
          'R',
          '',
          'I',
          '',
          '',
          'I',
          'T',
          '',
          '',
          '',
          '',
          'T',
          'I',
          'R',
          'E',
          '',
          '',
          '',
          '',
          '',
          '',
          '',
          '',
          'R',
        ],
      ),
      const LevelData(
        levelId: 2,
        words: ['SAW', 'WASP', 'SWAP', 'NAP', 'SPAWN'],
        boardHeight: 5,
        boardWidth: 5,
        boardData: [
          'W',
          '',
          'S',
          'A',
          'W',
          'A',
          '',
          'W',
          '',
          '',
          'S',
          'P',
          'A',
          'W',
          'N',
          'P',
          '',
          'P',
          '',
          'A',
          '',
          '',
          '',
          '',
          'P'
        ],
      ),
    ]);
    /*LevelData(boardData: [], levelId: 2, words: []),
      LevelData(boardData: [], levelId: 3, words: []),
      LevelData(boardData: [], levelId: 4, words: []),*/

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
