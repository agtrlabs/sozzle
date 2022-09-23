import 'package:sozzle/core/domain/level_data.dart';
import 'package:sozzle/core/domain/user_progress_data.dart';
import 'package:sozzle/src/apploader/apploader.dart';

class AppLoaderRepo implements AppLoaderRepository {
  LevelList list = LevelList([]);
  @override
  Future<LevelList> getLevels() async {
    
    //TODO: (akyunus) get data online
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
    var percent = 0.0;
    yield percent;
    final diff = 1 / list.levels.length;

    for (final level in list.levels) {
      //update percent
      percent += diff;
      yield percent;
    }
  }
}
