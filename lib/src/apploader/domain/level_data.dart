class LevelList {
  LevelList(this.levels);

  /// data list of all available levels
  List<LevelData> levels;
}

class LevelData {
  LevelData({
    required this.boardData,
    required this.levelId,
    required this.words,
  });

  /// The data required to draw puzzle board
  List<String> boardData;

  /// hidden goal words of the level
  List<String> words;

  /// level id
  int levelId;
}
