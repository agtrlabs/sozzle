//import 'package:http/http.dart' as http;
import 'package:sozzle/core/domain/i_level_repository.dart';
import 'package:sozzle/core/domain/level_data.dart';
import 'package:sozzle/core/domain/user_progress_data.dart';
import 'package:sozzle/src/apploader/apploader.dart';

class ApploaderRepository implements IApploaderRepository {
  ApploaderRepository(this.levelRepository);

  LevelList list = LevelList([]);

  @override
  ILevelRepository levelRepository;

  @override
  Future<LevelList> getLevels() async {
    // TODO(akyunus): get data online
    list.levels.addAll([
      LevelData(boardData: [], levelId: 1, words: []),
      LevelData(boardData: [], levelId: 2, words: []),
      LevelData(boardData: [], levelId: 3, words: []),
      LevelData(boardData: [], levelId: 4, words: []),
    ]);

    return list;
  }

  @override
  Future<UserProgressData> getUserProgressData() async {
    return UserProgressData(currentLevel: 1);
  }

  @override
  Stream<double> saveData() async* {
    /// progress percent
    var progress = 0.0;
    yield progress;
    final increment = 1 / list.levels.length;

    for (final level in list.levels) {
      await levelRepository.setLevel(level);
      //update percent
      progress += increment;
      //level save to file
      yield progress < 1 ? progress : 0.99;
    }

    yield 1;
  }
}
