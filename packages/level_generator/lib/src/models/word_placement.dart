/// Represents the placement of a word in the crossword grid.
/// Contains the word text, its starting position, and direction.
class WordPlacement {
  /// Represents the placement of a word in the crossword grid.
  /// Contains the word text, its starting position, and direction.
  const WordPlacement({
    required this.word,
    required this.x,
    required this.y,
    required this.isHorizontal,
  });

  /// The word text
  final String word;

  /// Starting x coordinate (column) in the normalized grid
  final int x;

  /// Starting y coordinate (row) in the normalized grid
  final int y;

  /// Whether the word is placed horizontally (true) or vertically (false)
  final bool isHorizontal;

  @override
  String toString() {
    return 'WordPlacement{'
        'word: $word, '
        'x: $x, '
        'y: $y, '
        '${isHorizontal ? 'horizontal' : 'vertical'}'
        '}';
  }
}
