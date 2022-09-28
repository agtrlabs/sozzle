import 'package:sozzle/src/level/models/level.dart';

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
      return '';
    } else if (_isRevealedLetter(index)) {
      final word =
          boardData.firstWhere((word) => word.positions.contains(index));
      return word.word[word.positions.indexOf(index)];
    } else {
      return '-';
    }
    // if (_getCellsWithData.contains(index)) {
    //   final word =
    //       boardData.firstWhere((word) => word.positions.contains(index));
    //   return word.word[word.positions.indexOf(index)];
    // } else {
    //   return '';
    // }
  }

  List<String> get getUniqueLetters =>
      words.join().toUpperCase().split('').toSet().toList();

  void shuffle() => words.shuffle();

  void wordIsFound(String word) => _foundWords.add(word);
}
