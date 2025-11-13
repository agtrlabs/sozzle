import 'dart:developer' as dev;
import 'dart:math';

import 'package:equatable/equatable.dart';

// ######################################################################
// # Public-Facing Data Structure for the Result
// ######################################################################

/// A class to hold the final generated crossword grid.
/// It contains the 2D grid data, width, and height.
class CrosswordGrid {
  /// A class to hold the final generated crossword grid.
  /// It contains the 2D grid data, width, and height.
  const CrosswordGrid({
    required this.gridData,
    required this.width,
    required this.height,
  });

  /// The 2D representation of the grid, e.g.,
  /// [
  ///   ['W', '', 'S', 'A', 'W'],
  ///   ['A', '', 'W', '', ''],
  ///   ...
  /// ]
  final List<List<String>> gridData;

  /// The final width of the grid.
  final int width;

  /// The final height of the grid.
  final int height;

  /// A helper function to print the grid to the console for debugging.
  void printGrid() {
    dev.log(
      'Grid Dimensions: ${width}w x ${height}h',
      name: 'CrosswordGrid.printGrid',
    );
    for (final row in gridData) {
      // Join cells, replacing empty strings with a dot for readability.
      final rowString = row.map((cell) => cell.isEmpty ? '.' : cell).join(' ');
      dev.log(rowString, name: 'CrosswordGrid.printGrid');
    }
  }

  /// Flattens the 2D [gridData] into the 1D `boardData` format
  /// your game expects.
  List<String> get flattenedBoardData {
    final flatList = <String>[];
    gridData.forEach(flatList.addAll);
    return flatList;
  }
}

// ######################################################################
// # The Crossword Generator
// ######################################################################

/// Main class that orchestrates the crossword generation.
/// It uses a recursive backtracking algorithm.
class CrosswordGenerator {
  /// Generates a crossword grid from a list of words.
  /// Returns a [CrosswordGrid] object if a solution is found,
  /// otherwise returns null.
  @Deprecated(
    'Use the compact version of the crossword generator instead. It'
    ' is more complete and robust.',
  )
  const CrosswordGenerator({this.shuffle = true});

  /// Whether to shuffle placements to get different layouts
  final bool shuffle;

  /// Generates the crossword grid.
  /// [words]: The list of words to place on the grid.
  ///
  /// Returns a [CrosswordGrid] if successful, or `null` if
  /// no valid arrangement could be found.
  CrosswordGrid? generate(List<String> words) {
    // 1. Sort words from longest to shortest. This is a common
    //    heuristic to make generation more likely to succeed,
    //    as it places the most "difficult" words first.
    final sortedWords = List<String>.from(words)
      ..sort((a, b) => b.length.compareTo(a.length));

    // 2. Start with an empty grid and place the first (longest) word.
    final grid = _Grid();
    final firstWord = sortedWords.first;
    final remainingWords = sortedWords.sublist(1);

    // Place the first word horizontally at (0, 0)
    grid.placeWord(
      firstWord,
      _Placement(word: firstWord, x: 0, y: 0, isHorizontal: true),
    );

    // 3. Start the recursive backtracking algorithm
    final solvedGrid = _solve(grid, remainingWords);

    // 4. If a solution was found, normalize it into the final
    //    CrosswordGrid format.
    if (solvedGrid != null) {
      return _normalizeGrid(solvedGrid);
    }

    // 5. No solution found
    return null;
  }

  /// The core recursive backtracking function.
  ///
  /// [grid]: The current state of the grid.
  /// [wordsToPlace]: The list of words we still need to place.
  ///
  /// Returns a solved [_Grid] if successful, or `null` if this
  /// branch is a dead end.
  _Grid? _solve(_Grid grid, List<String> wordsToPlace) {
    // BASE CASE: If there are no more words to place, we are done!
    if (wordsToPlace.isEmpty) {
      return grid;
    }

    // RECURSIVE STEP:
    final word = wordsToPlace.first;
    final remainingWords = wordsToPlace.sublist(1);

    // 1. Find all possible valid placements for the current word.
    final placements = _findAllValidPlacements(grid, word);

    // Optional: Shuffle placements to get different grid layouts
    // on different runs.
    if (shuffle) {
      placements.shuffle();
    }

    // 2. Try each placement one by one.
    for (final placement in placements) {
      // 2a. "Commit" the placement to a *new* grid.
      final newGrid = grid.copy()..placeWord(word, placement);

      // 2b. Recursively try to solve for the *rest* of the words.
      final solution = _solve(newGrid, remainingWords);

      // 2c. If the recursive call found a solution, pass it up.
      if (solution != null) {
        return solution;
      }

      // 2d. If not, this placement was a dead end. The loop will
      //     continue to the next placement (i.e., we "backtracked").
    }

    // 3. If we tried all placements and none worked, this branch fails.
    return null;
  }

  /// Finds all possible valid placements for a new [word] on the
  /// existing [grid].
  List<_Placement> _findAllValidPlacements(_Grid grid, String word) {
    final validPlacements = <_Placement>[];

    // Iterate through every word *already on the grid*
    for (final placedWord in grid.placedWords) {
      final isHorizontal = placedWord.isHorizontal;
      final newWordIsHorizontal = !isHorizontal;

      // Iterate through each letter of the new word
      for (var i = 0; i < word.length; i++) {
        final newWordChar = word[i];

        // Iterate through each letter of the existing word
        for (var j = 0; j < placedWord.word.length; j++) {
          final placedWordChar = placedWord.word[j];

          // Check for an intersection (matching character)
          if (newWordChar == placedWordChar) {
            // We found a potential intersection!
            // Now calculate the (x, y) starting position
            // for the new word.
            int newX;
            int newY;
            if (newWordIsHorizontal) {
              // New word is horizontal, old word is vertical
              newX = placedWord.x - i;
              newY = placedWord.y + j;
            } else {
              // New word is vertical, old word is horizontal
              newX = placedWord.x + j;
              newY = placedWord.y - i;
            }

            final placement = _Placement(
              word: word,
              x: newX,
              y: newY,
              isHorizontal: newWordIsHorizontal,
            );

            // Check if this placement is *actually* valid
            // (i.e., doesn't collide or create bad words)
            if (_isValidPlacement(grid, placement)) {
              validPlacements.add(placement);
            }
          }
        }
      }
    }
    return validPlacements;
  }

  /// This is the most complex logic.
  /// Checks if a [placement] is valid on the [grid].
  ///
  /// A placement is valid if:
  /// 1. It doesn't collide with existing letters (unless
  ///    it's an intersection point).
  /// 2. It doesn't create new "accidental" words by
  ///    running parallel to an existing word.
  /// 3. The cells before the start and after the end are empty.
  bool _isValidPlacement(_Grid grid, _Placement placement) {
    final word = placement.word;

    // We must intersect with at least one word.
    // (This check is implicitly handled by _findAllValidPlacements,
    // but we can add a counter if we want to be explicit)
    // ignore: unused_local_variable
    var intersections = 0;

    for (var k = 0; k < word.length; k++) {
      final letter = word[k];
      final coord = placement.getCoordinate(k);

      final cell = grid.cells[coord];

      if (cell != null) {
        // Cell is NOT empty
        if (cell != letter) {
          // 1. COLLISION: Cell has a *different* letter. Invalid.
          return false;
        } else {
          // 1b. INTERSECTION: Cell has the *same* letter. This is
          //     our intersection point. This is fine.
          intersections++;
        }
      } else {
        // Cell IS empty.
        // 2. ADJACENCY CHECK: Check for "accidental" parallel words.
        _Coordinate adjacent1;
        _Coordinate adjacent2;
        if (placement.isHorizontal) {
          // Check cells above (y-1) and below (y+1)
          adjacent1 = coord.copy(y: coord.y - 1);
          adjacent2 = coord.copy(y: coord.y + 1);
        } else {
          // Check cells left (x-1) and right (x+1)
          adjacent1 = coord.copy(x: coord.x - 1);
          adjacent2 = coord.copy(x: coord.x + 1);
        }

        if (grid.cells.containsKey(adjacent1) ||
            grid.cells.containsKey(adjacent2)) {
          // This empty cell is adjacent to another word it's
          // not intersecting with. This is invalid.
          return false;
        }
      }
    }

    // 3. END-CAP CHECK: Check before the start and after the end
    //    of the word. These cells MUST be empty.
    _Coordinate before;
    _Coordinate after;
    if (placement.isHorizontal) {
      before = _Coordinate(x: placement.x - 1, y: placement.y);
      after = _Coordinate(x: placement.x + word.length, y: placement.y);
    } else {
      before = _Coordinate(x: placement.x, y: placement.y - 1);
      after = _Coordinate(x: placement.x, y: placement.y + word.length);
    }

    if (grid.cells.containsKey(before) || grid.cells.containsKey(after)) {
      return false;
    }

    // If we've passed all checks, it's a valid placement.
    return true;
  }

  /// Converts the internal [_Grid] (sparse map) into the
  /// final [CrosswordGrid] (dense 2D list).
  CrosswordGrid _normalizeGrid(_Grid grid) {
    if (grid.cells.isEmpty) {
      return const CrosswordGrid(gridData: [], width: 0, height: 0);
    }

    // 1. Find the bounds of the sparse grid.
    var minX = 0;
    var maxX = 0;
    var minY = 0;
    var maxY = 0;
    for (final coord in grid.cells.keys) {
      minX = min(minX, coord.x);
      maxX = max(maxX, coord.x);
      minY = min(minY, coord.y);
      maxY = max(maxY, coord.y);
    }

    // 2. Calculate final width and height
    final width = maxX - minX + 1;
    final height = maxY - minY + 1;

    // 3. Create the 2D "dense" list, filled with empty strings.
    final denseGrid = List<List<String>>.generate(
      height,
      (_) => List.filled(width, ''),
    );

    // 4. Copy data from the sparse grid to the dense grid,
    //    normalizing coordinates.
    for (final entry in grid.cells.entries) {
      final coord = entry.key;
      final letter = entry.value;

      // Normalize coordinates
      final row = coord.y - minY;
      final col = coord.x - minX;

      denseGrid[row][col] = letter;
    }

    return CrosswordGrid(gridData: denseGrid, width: width, height: height);
  }
}

// ######################################################################
// # Internal Helper Classes
// ######################################################################

/// Represents a 2D coordinate.
/// Using a class makes it usable as a Map key.
class _Coordinate extends Equatable {
  const _Coordinate({required this.x, required this.y});

  final int x;
  final int y;

  _Coordinate copy({int? x, int? y}) =>
      _Coordinate(x: x ?? this.x, y: y ?? this.y);

  @override
  String toString() => '($x, $y)';

  @override
  List<Object?> get props => [x, y];
}

/// Represents a word placed on the grid.
class _Placement {
  _Placement({
    required this.word,
    required this.x,
    required this.y,
    required this.isHorizontal,
  });

  final String word;

  /// Starting x coordinate
  final int x;

  /// Starting y coordinate
  final int y;
  final bool isHorizontal;

  /// Gets the coordinate for the k-th letter of the word.
  _Coordinate getCoordinate(int k) {
    return isHorizontal
        ? _Coordinate(x: x + k, y: y)
        : _Coordinate(x: x, y: y + k);
  }
}

/// Internal representation of the grid.
/// Uses a "sparse" map of Coordinates to letters, so it
/// can grow infinitely in any direction.
class _Grid {
  // A map of coordinates to the letter at that spot
  final Map<_Coordinate, String> cells = {};

  // A list of all words placed so far
  final List<_Placement> placedWords = [];

  /// Creates a deep copy of the grid.
  /// This is crucial for backtracking.
  _Grid copy() {
    final newGrid = _Grid();
    newGrid.cells.addAll(cells);
    newGrid.placedWords.addAll(placedWords);
    return newGrid;
  }

  /// "Commits" a word to the grid by adding its letters
  /// to the [cells] map and adding the [placement] to
  /// the [placedWords] list.
  void placeWord(String word, _Placement placement) {
    placedWords.add(placement);
    for (var k = 0; k < word.length; k++) {
      final coord = placement.getCoordinate(k);
      cells[coord] = word[k];
    }
  }
}
