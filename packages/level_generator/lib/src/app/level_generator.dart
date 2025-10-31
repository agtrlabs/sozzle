import 'dart:developer';
import 'dart:math' as math;

import 'package:level_data/level_data.dart';
import 'package:level_generator/src/app/crossword_generator_compact.dart';
import 'package:level_generator/src/app/word_list_service.dart';
import 'package:level_generator/src/models/difficulty_config.dart';
import 'package:level_generator/src/models/word_placement.dart';
import 'package:level_generator/src/services/defintion_fetcher.dart';

/// Main class responsible for generating levels.
class LevelGenerator {
  /// The engine that generates everything needed for a crossword level.
  const LevelGenerator({
    required CrosswordGenerator crosswordGenerator,
    required WordListService wordListService,
    required DefinitionFetcher definitionFetcher,
  }) : _crosswordGenerator = crosswordGenerator,
       _wordListService = wordListService,
       _definitionFetcher = definitionFetcher;

  final CrosswordGenerator _crosswordGenerator;
  final WordListService _wordListService;
  final DefinitionFetcher _definitionFetcher;

  /// Generates a level based on the given level number.
  ////
  /// This includes selecting words, generating the crossword grid,
  /// and fetching definitions.
  Future<LevelData> generateLevel({required int level}) async {
    log('Generating level $level', name: 'LevelGenerator.generateLevel');
    if (_wordListService.words.isEmpty) {
      await _wordListService.loadWords();
    }

    log(
      'Word list loaded with ${_wordListService.words.length} words',
      name: 'LevelGenerator.generateLevel',
    );

    log(
      'Calculating difficulty for level $level',
      name: 'LevelGenerator.generateLevel',
    );
    final difficulty = _calculateDifficulty(level);

    log(
      'Difficulty for level $level: ${difficulty.difficulty}',
      name: 'LevelGenerator.generateLevel',
    );

    final levelWords = _wordListService.getWordsForLevel(
      levelNumber: level,
      count: difficulty.maxWordLength,
      minLength: difficulty.minWordLength,
      maxLength: difficulty.maxWordLength,
    );

    log(
      'Selected ${levelWords.length} words for level $level: $levelWords',
      name: 'LevelGenerator.generateLevel',
    );

    final grid = _crosswordGenerator.generate(levelWords);

    if (grid == null) {
      log(
        'Invalid grid generated for level $level',
        name: 'LevelGenerator.generateLevel',
      );
      return generateLevel(level: level);
    }

    log(
      'Generated grid for level $level: ${grid.width}x${grid.height}',
      name: 'LevelGenerator.generateLevel',
    );

    final wordDefinitionMap = await _definitionFetcher.fetchDefinitions(
      levelWords,
    );

    // Create Crossword objects from word placements
    final crosswords = _createCrosswordsFromPlacements(
      grid.wordPlacements,
      wordDefinitionMap,
    );

    return LevelData(
      levelId: level,
      words: levelWords,
      boardWidth: grid.width,
      boardHeight: grid.height,
      boardData: grid.flattenedBoardData,
      crosswords: crosswords,
    );
  }

  /// Creates a map of Crossword objects from word placements.
  ///
  /// The directionIndex is assigned sequentially for each direction
  /// (across and down separately), starting from 1.
  Map<String, Crossword> _createCrosswordsFromPlacements(
    List<WordPlacement> placements,
    Map<String, String?> definitionMap,
  ) {
    final crosswords = <String, Crossword>{};

    // Separate placements by direction and sort by position
    final acrossWords = placements.where((p) => p.isHorizontal).toList()
      ..sort((a, b) {
        // Sort by row (y), then by column (x)
        final yCompare = a.y.compareTo(b.y);
        return yCompare != 0 ? yCompare : a.x.compareTo(b.x);
      });

    final downWords = placements.where((p) => !p.isHorizontal).toList()
      ..sort((a, b) {
        // Sort by column (x), then by row (y)
        final xCompare = a.x.compareTo(b.x);
        return xCompare != 0 ? xCompare : a.y.compareTo(b.y);
      });

    // Assign directionIndex for across words
    for (var i = 0; i < acrossWords.length; i++) {
      final placement = acrossWords[i];
      final word = placement.word.toUpperCase();
      crosswords[word] = Crossword(
        word: word,
        direction: CrossWordDirection.across,
        directionIndex: i + 1,
        definition: definitionMap[word],
      );
    }

    // Assign directionIndex for down words
    for (var i = 0; i < downWords.length; i++) {
      final placement = downWords[i];
      final word = placement.word.toUpperCase();
      crosswords[word] = Crossword(
        word: word,
        direction: CrossWordDirection.down,
        directionIndex: i + 1,
        definition: definitionMap[word],
      );
    }

    return crosswords;
  }

  DifficultyConfig _calculateDifficulty(int levelNumber) {
    if (levelNumber <= 5) {
      return DifficultyConfig.easy();
    }
    if (levelNumber <= 15) {
      return DifficultyConfig.medium();
    }

    final base = DifficultyConfig.hard();
    final extraWords = (levelNumber - 15) ~/ 3;
    final timeReduction = (levelNumber - 15) * 5;

    return base.copyWith(
      maxWordsPerLevel: base.maxWordsPerLevel + extraWords,
      timeLimit: math.max(60, base.timeLimit - timeReduction),
    );
  }
}
