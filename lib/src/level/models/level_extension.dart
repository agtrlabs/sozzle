import 'package:sozzle/src/level/models/level.dart';

enum ReveilSelection {
  concealed,
  blocked,
}

extension LevelExtension on LevelData {
  bool includesWord(String word) => words.contains(word);
  static final List<String> _foundWords = [];

  List<int> get _getCellsWithData => boardData
      .map((e) => e.positions)
      .expand<int>((element) => element)
      .toList();

  bool _isRevealedLetter(int idx) =>
      boardData.where((word) => word.revealed).any(
            (e) => e.positions.contains(idx),
          );

  String getCellValue(int index) {
    if (!_getCellsWithData.contains(index)) {
      return ReveilSelection.blocked.name;
    } else if (_isRevealedLetter(index)) {
      final word =
          boardData.firstWhere((word) => word.positions.contains(index));
      return word.word[word.positions.indexOf(index)];
    } else {
      return ReveilSelection.concealed.name;
    }
  }

  List<String> get _uniqueLetters =>
      words.join().toUpperCase().split('').toSet().toList();

  static final List<String> _letters = [];

  List<String> get getUniqueLetters {
    if (_letters.isEmpty) _letters.addAll(_uniqueLetters);
    return _letters;
  }

  void shuffle() => _letters.shuffle();

  void wordIsFound(String word) => _foundWords.add(word);
}

extension WordPositionsExt on WordPosition {
  void reveal() => revealed = true;
}
