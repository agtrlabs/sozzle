import 'package:level_data/src/crossword_base.dart';

extension StringExtensions on String {
  CrossWordDirection toDirection() {
    for (final direction in CrossWordDirection.values) {
      if (direction.value == toLowerCase()) {
        return direction;
      }
    }
    throw Exception('Invalid direction string: $this');
  }
}
