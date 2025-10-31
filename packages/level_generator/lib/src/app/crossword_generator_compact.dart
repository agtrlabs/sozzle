import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:level_generator/src/models/crossword_grid.dart';
import 'package:level_generator/src/models/word_placement.dart';

/// Main class that orchestrates the crossword generation.
/// It uses a recursive backtracking algorithm.
class CrosswordGenerator {
  /// Stores the best grid found so far during the search.
  _Grid? _bestSolution;

  /// Stores the area of the best grid found so far.
  /// -1 indicates no solution has been found yet.
  int _minArea = -1;

  /// Generates a crossword grid from a list of words.
  /// Returns a [CrosswordGrid] object if a solution is found,
  /// otherwise returns null.
  CrosswordGrid? generate(List<String> words) {
    // 0. Reset state for a new generation
    _bestSolution = null;
    _minArea = -1;

    // 1. Sort words from longest to shortest. This is a common
    //    heuristic to make generation more likely to succeed,
    //    as it places the most "difficult" words first.
    final sortedWords = List<String>.from(words)
      ..sort((a, b) => b.length.compareTo(a.length));

    // 2. Start with an empty grid and place the first (longest) word.
    //    We must try starting both horizontally AND vertically to find
    //    the true most compact solution.
    final firstWord = sortedWords.first;
    final remainingWords = sortedWords.sublist(1);

    // --- Try 1: Start with the first word placed horizontally ---
    final gridH = _Grid()
      ..placeWord(
        firstWord,
        _Placement(word: firstWord, x: 0, y: 0, isHorizontal: true),
      );
    // 3. Start the recursive backtracking algorithm
    _solve(gridH, remainingWords);

    // --- Try 2: Start with the first word placed vertically ---
    final gridV = _Grid()
      ..placeWord(
        firstWord,
        _Placement(word: firstWord, x: 0, y: 0, isHorizontal: false),
      );
    // 3. Start the recursive backtracking algorithm again
    _solve(gridV, remainingWords);

    // 4. After all searches are complete, _bestSolution holds the
    //    most compact grid found. Normalize it.
    if (_bestSolution != null) {
      return _normalizeGrid(_bestSolution!);
    }

    // 5. No solution found
    return null;
  }

  /// The core recursive backtracking function.
  ///
  /// [grid]: The current state of the grid.
  /// [wordsToPlace]: The list of words we still need to place.
  ///
  /// This function now has a `void` return. It explores all valid
  /// solution paths and updates the class members `_bestSolution`
  /// and `_minArea` when a new, better solution is found.
  void _solve(_Grid grid, List<String> wordsToPlace) {
    // BASE CASE: If there are no more words to place, we found a
    // complete solution.
    if (wordsToPlace.isEmpty) {
      final bounds = grid.getBounds();
      final currentArea = bounds.area;

      // Check if this solution is better than our current best.
      if (_bestSolution == null || currentArea < _minArea) {
        _minArea = currentArea;
        _bestSolution = grid.copy();
      }
      return;
    }

    // --- PRUNING STEP ---
    // If the grid we're building is *already* bigger than our
    // best-known solution, there's no point continuing.
    // This is the "bound" in "branch and bound".
    if (_minArea != -1) {
      final currentBounds = grid.getBounds();
      if (currentBounds.area >= _minArea) {
        return; // Prune this branch
      }
    }

    // RECURSIVE STEP:
    final word = wordsToPlace.first;
    final remainingWords = wordsToPlace.sublist(1);

    // 1. Find all possible valid placements for the current word.
    final placements = _findAllValidPlacements(grid, word)
      // Optional: Shuffle placements to get different grid layouts
      // on different runs.
      ..shuffle();

    // 2. Try each placement one by one.
    for (final placement in placements) {
      // 2a. "Commit" the placement to a *new* grid.
      final newGrid = grid.copy()..placeWord(word, placement);

      // 2b. Recursively try to solve for the *rest* of the words.
      _solve(newGrid, remainingWords);

      // 2c. After the recursive call, we just continue to the
      //     next placement. We don't return here, because we
      //     need to check ALL possible branches.
    }

    // 3. If we tried all placements, this branch is done.
    //    (No return null, as the function is void)
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
          // (Removed redundant 'intersections++')
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
      return const CrosswordGrid(
        gridData: [],
        width: 0,
        height: 0,
        wordPlacements: [],
      );
    }

    // 1. Find the bounds of the sparse grid.
    final bounds = grid.getBounds();
    final width = bounds.width;
    final height = bounds.height;

    if (width <= 0 || height <= 0) {
      return const CrosswordGrid(
        gridData: [],
        width: 0,
        height: 0,
        wordPlacements: [],
      );
    }

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
      final row = coord.y - bounds.minY;
      final col = coord.x - bounds.minX;

      denseGrid[row][col] = letter;
    }

    // 5. Convert internal placements to public WordPlacement objects,
    //    normalizing their coordinates as well.
    final wordPlacements = grid.placedWords.map((
      placement,
    ) {
      return WordPlacement(
        word: placement.word,
        x: placement.x - bounds.minX,
        y: placement.y - bounds.minY,
        isHorizontal: placement.isHorizontal,
      );
    }).toList();

    return CrosswordGrid(
      gridData: denseGrid,
      width: width,
      height: height,
      wordPlacements: wordPlacements,
    );
  }
}

// ######################################################################
// # Internal Helper Classes
// ######################################################################

/// Represents the min/max bounds of the grid.
class _Bounds {
  _Bounds(this.minX, this.maxX, this.minY, this.maxY);

  final int minX;
  final int maxX;
  final int minY;
  final int maxY;

  /// Calculates the width of the bounding box.
  int get width => (maxX - minX) + 1;

  /// Calculates the height of the bounding box.
  int get height => (maxY - minY) + 1;

  /// Calculates the total area of the bounding box.
  int get area => width * height;
}

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

  /// Calculates the current bounding box of the grid.
  _Bounds getBounds() {
    if (cells.isEmpty) {
      return _Bounds(0, 0, 0, 0);
    }

    var minX = 0;
    var maxX = 0;
    var minY = 0;
    var maxY = 0;
    var first = true;

    for (final coord in cells.keys) {
      if (first) {
        minX = maxX = coord.x;
        minY = maxY = coord.y;
        first = false;
      } else {
        minX = min(minX, coord.x);
        maxX = max(maxX, coord.x);
        minY = min(minY, coord.y);
        maxY = max(maxY, coord.y);
      }
    }
    return _Bounds(minX, maxX, minY, maxY);
  }
}
