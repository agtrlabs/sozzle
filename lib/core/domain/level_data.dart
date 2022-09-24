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

  factory LevelData.fromMap(Map<String, dynamic> json) => LevelData(
        levelId: json['id'] as int,
        boardData: List<String>.from(
          (json['board'] as Iterable<String>).map((x) => x),
        ),
        words: List<String>.from(
          (json['words'] as Iterable<String>).map((x) => x),
        ),
      );

  /// The data required to draw puzzle board
  List<String> boardData;

  /// hidden goal words of the level
  List<String> words;

  /// level id
  int levelId;

  Map<String, dynamic> toMap() => {
        'id': levelId,
        'board': List<dynamic>.from(boardData.map((x) => x)),
        'words': List<dynamic>.from(words.map((x) => x)),
      };
}
