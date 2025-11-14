import 'dart:developer' as dev;

import 'package:level_generator/src/models/word_placement.dart';

/// A class to hold the final generated crossword grid.
/// It contains the 2D grid data, width, height, and word placements.
class CrosswordGrid {
  /// A class to hold the final generated crossword grid.
  /// It contains the 2D grid data, width, height, and word placements.
  const CrosswordGrid({
    required this.gridData,
    required this.width,
    required this.height,
    required this.wordPlacements,
  });

  @override
  String toString() {
    return 'CrosswordGrid{'
        'gridData: ${gridData.take(5)}..., '
        'width: $width, '
        'height:$height, '
        'words: ${wordPlacements.length}'
        '}';
  }

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

  /// List of all word placements in the grid with their positions and
  /// directions.
  final List<WordPlacement> wordPlacements;

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
  ///
  /// LevelData uses column-major order: index = col * height + row
  /// So we iterate columns first, then rows.
  List<String> get flattenedBoardData {
    final flatList = <String>[];
    for (var col = 0; col < width; col++) {
      for (var row = 0; row < height; row++) {
        flatList.add(gridData[row][col]);
      }
    }
    return flatList;
  }
}
