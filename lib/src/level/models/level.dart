import 'dart:math';

class LevelList {
  LevelList(this.levels);

  /// data list of all available levels
  List<LevelData> levels;
}

class LevelData {
  LevelData({
    // required this.boardData,
    required this.levelId,
    required this.words,
    required this.grid,
    required this.boardData,
  });

  factory LevelData.fromMap(Map<String, dynamic> json) => LevelData(
        levelId: json['id'] as int,
        // boardData: List<String>.from(
        //   (json['board'] as Iterable<String>).map((x) => x),
        // ),
        words: List<String>.from(
          (json['words'] as List<dynamic>).map((x) => x),
        ),
        grid: BoardGrid.fromMap(json['grid'] as Map<String, dynamic>),
        boardData: List<Map<String, dynamic>>.from(
          json['boardData'] as Iterable<dynamic>,
        ).map(WordPosition.fromMap).toList(),
      );

  // /// The data required to draw puzzle board
  // List<String> boardData;

  /// hidden goal words of the level
  List<String> words;

  /// level id
  int levelId;

  /// grid size
  BoardGrid grid;

  /// Positions of each letter from each word
  List<WordPosition> boardData;

  Map<String, dynamic> toMap() => {
        'id': levelId,
        // 'board': List<dynamic>.from(boardData.map((x) => x)),
        'words': List<dynamic>.from(words.map((x) => x)),
      };

  void shuffle() => words.shuffle();
}

class BoardGrid {
  BoardGrid(int _rows, int _cols)
      : rows = max(_rows, _cols),
        cols = max(_rows, _cols);

  factory BoardGrid.fromMap(Map<String, dynamic> json) => BoardGrid(
        json['rows'] as int,
        json['cols'] as int,
      );

  final int rows;
  final int cols;

  Map<String, dynamic> toMap() => {
        'rows': rows,
        'cols': cols,
      };

  // int get maxSize => max(cols, rows);
}

class WordPosition {
  WordPosition({
    required this.word,
    required this.positions,
    this.revealed = false,
  });

  factory WordPosition.fromMap(Map<String, dynamic> json) {
    return WordPosition(
      word: json.keys.first,
      positions: List<int>.from(json.values.first as List<dynamic>),
    );
  }

  final String word;
  final List<int> positions;
  bool revealed;

  @override
  String toString() {
    return 'word: $word, revealed: $revealed';
  }

  WordPosition copyWith({
    String? word,
    List<int>? positions,
    bool? revealed,
  }) {
    return WordPosition(
      word: word ?? this.word,
      positions: positions ?? this.positions,
      revealed: revealed ?? this.revealed,
    );
  }

  void reveal() => revealed = true;
}
