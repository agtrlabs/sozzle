import 'package:sozzle/src/apploader/apploader.dart';

class AppLoaderRepo implements AppLoaderRepository {
  @override
  Future<LevelList> getLevels() async {
    return LevelList([
      LevelData(boardData: [], levelId: 1, words: []),
      LevelData(boardData: [], levelId: 2, words: []),
      LevelData(boardData: [], levelId: 3, words: []),
      LevelData(boardData: [], levelId: 4, words: []),
    ]);
  }

  @override
  Future<UserProgressData> getUserProgressData() async {
    return UserProgressData(currentLevel: 1);
  }
}
