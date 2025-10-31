import 'package:equatable/equatable.dart';
import 'package:level_data/core/extensions/string_extensions.dart';

/// The direction of the crossword word
enum CrossWordDirection {
  /// The word is placed horizontally
  across('across'),

  /// The word is placed vertically
  down('down');

  const CrossWordDirection(this.value);

  /// The string value of the direction
  final String value;
}

/// A model representing a crossword word with its properties
class Crossword extends Equatable {
  /// Creates a [Crossword] instance
  const Crossword({
    required this.word,
    required this.direction,
    required this.directionIndex,
    this.definition,
  });

  /// Creates a [Crossword] instance from a map
  factory Crossword.fromMap(Map<String, dynamic> map) {
    return Crossword(
      word: map['word'] as String,
      definition: map['definition'] as String?,
      direction: (map['direction'] as String).toDirection(),
      directionIndex: (map['directionIndex'] as num).toInt(),
    );
  }

  /// The crossword word
  final String word;

  /// The definition of the crossword word
  final String? definition;

  /// The direction of the crossword word
  final CrossWordDirection direction;

  /// The index of the direction (row or column)
  final int directionIndex;

  /// Creates a copy of the current [Crossword] with optional new values
  Crossword copyWith({
    String? word,
    String? definition,
    CrossWordDirection? direction,
    int? directionIndex,
  }) {
    return Crossword(
      word: word ?? this.word,
      definition: definition ?? this.definition,
      direction: direction ?? this.direction,
      directionIndex: directionIndex ?? this.directionIndex,
    );
  }

  /// Converts the [Crossword] instance to a map
  Map<String, dynamic> toMap() {
    return {
      'word': word,
      'definition': definition,
      'direction': direction.value,
      'directionIndex': directionIndex,
    };
  }

  @override
  List<Object?> get props => [word, direction, directionIndex, definition];
}
