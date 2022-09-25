import 'dart:math';

class WordList {
  const WordList({
    required this.words,
    required this.grid,
  });

  final List<LetterGrid> words;
  final GridPosition grid;
}

class Word {
  const Word(this.name, this.letters);

  factory Word.fromMap(Map<String, dynamic> map) {
    final name = map.keys.first;
    final letterJson = (map[name] as Map<String, dynamic>).entries.toList();
    final letters = letterJson
        .map<LetterGrid>(
          (MapEntry<String, dynamic> letter) =>
              LetterGrid.fromMap({letter.key: letter.value}),
        )
        .toList();
    return Word(name, letters);
  }

  final String name;
  final List<LetterGrid> letters;
}

class LetterGrid {
  const LetterGrid({
    required this.letter,
    required this.wordPosition,
  });

  factory LetterGrid.fromMap(Map<String, dynamic> map) {
    final letter = map.keys.first;

    // final wordPosition = (map[letter] as List<dynamic>).cast<int>().toList();
    // return LetterGrid(
    //   letter: letter,
    //   wordPosition: GridPosition(
    //     row: wordPosition[0],
    //     col: wordPosition[1],
    //   ),
    // );
    final wordPosition = (map[letter] as List<dynamic>).cast<int>().toList();
    return LetterGrid(
      letter: letter,
      wordPosition: LetterPosition.fromList(wordPosition),
    );
  }

  final String letter;
  // final GridPosition wordPosition;
  final LetterPosition wordPosition;
}

class LetterPosition {
  const LetterPosition({
    required this.row,
    required this.col,
  });

  factory LetterPosition.fromList(List<int> list) {
    final row = list[0];
    final col = list[1];
    return LetterPosition(row: row, col: col);
  }

  final int row;
  final int col;
}

class GridPosition {
  const GridPosition({
    required this.row,
    required this.col,
  });

  factory GridPosition.fromMap(Map<String, dynamic> map) {
    final grid = (map['grid'] as List<dynamic>).cast<int>().toList();
    final row = grid[0];
    final col = grid[1];
    return GridPosition(row: row, col: col);
  }

  final int row;
  final int col;

  int get maxSize => max(row, col);
}
