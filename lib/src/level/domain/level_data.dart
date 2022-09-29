class LevelData {
  LevelData({
    required this.boardData,
    required this.boardWidth,
    required this.boardHeight,
    required this.levelId,
    required this.words,
  });

  factory LevelData.fromMap(Map<String, dynamic> json) => LevelData(
        levelId: json['id'] as int,
        boardHeight: json['rows'] as int,
        boardWidth: json['cols'] as int,
        boardData: List<String>.from(
          (json['board'] as Iterable<String>).map((x) => x),
        ),
        words: List<String>.from(
          (json['words'] as Iterable<String>).map((x) => x),
        ),
      );

  /// The data required to draw puzzle board
  List<String> boardData;

  /// Count of columns
  int boardWidth;

  /// Count of Rows
  int boardHeight;

  /// hidden goal words of the level
  List<String> words;

  /// level id
  int levelId;

  Map<String, dynamic> toMap() => {
        'id': levelId,
        'board': List<dynamic>.from(boardData.map((x) => x)),
        'words': List<dynamic>.from(words.map((x) => x)),
        'rows': boardHeight,
        'cols': boardWidth,
      };
}

class LevelList {
  LevelList(this.levels);

  /// data list of all available levels
  List<LevelData> levels;
}
