import 'package:level_data/src/crossword_base.dart';

/// Extensions on the String data type.
extension StringExtensions on String {
  /// Converts a string to a [CrossWordDirection].
  CrossWordDirection toDirection() {
    for (final direction in CrossWordDirection.values) {
      if (direction.value == toLowerCase()) {
        return direction;
      }
    }
    throw Exception('Invalid direction string: $this');
  }
}
