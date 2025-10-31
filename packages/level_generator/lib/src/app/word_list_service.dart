import 'dart:collection';
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';

// import 'package:flutter/services.dart';

/// Service for managing word lists and selecting appropriate words for levels.
class WordListService {
  /// Service for managing word lists and selecting appropriate words for
  /// levels.
  WordListService({
    String? wordListPath,
    Random? random,
  }) : _wordListPath = wordListPath ?? 'assets/words/wordlist.txt',
       _random = random ?? Random();

  final String _wordListPath;
  final Random _random;

  List<String> _words = [];

  int _loadAttempts = 0;

  /// Get an unmodifiable view of the full word list.
  UnmodifiableListView<String> get words => UnmodifiableListView(_words);

  /// Get words for a level with specific constraints.
  List<String> getWordsForLevel({
    /// The current level number.
    required int levelNumber,

    /// The number of words to select.
    required int count,

    /// Minimum word length.
    int? minLength,

    /// Maximum word length.
    int? maxLength,
  }) {
    // As level increases, allow longer words
    final effectiveMinLength = minLength ?? 3;
    final effectiveMaxLength = maxLength ?? _calculateMaxLength(levelNumber);
    final candidates = _words.where((word) {
      final length = word.length;
      return length >= effectiveMinLength && length <= effectiveMaxLength;
    }).toList();

    if (candidates.isEmpty) {
      dev.log(
        'No candidate words found for level $levelNumber '
        'with lengths between $effectiveMinLength and $effectiveMaxLength',
        name: 'WordListService.getWordsForLevel',
      );
      throw StateError(
        'No words available matching constraints: '
        'min=$effectiveMinLength, max=$effectiveMaxLength',
      );
    }

    dev.log(
      'Found ${candidates.length} candidate words for level $levelNumber '
      'with lengths between $effectiveMinLength and $effectiveMaxLength',
      name: 'WordListService.getWordsForLevel',
    );

    List<String> selectedWords;
    const maxAttempts = 50; // Safety break for finding a connected list
    var attempts = 0;

    do {
      dev.log(
        'Attempt ${attempts + 1} to select connected '
        'words for level $levelNumber',
        name: 'WordListService.getWordsForLevel',
      );
      if (attempts >= maxAttempts) {
        // If we fail to find a connected list after 50 attempts,
        // we return the best-effort list and rely on the
        // CrosswordGenerator to filter it out (though this is rare).
        dev.log(
          'Warning: Failed to find a connected word list '
          'after $maxAttempts attempts.',
          name: 'WordListService.getWordsForLevel',
        );
        selectedWords = candidates.take(count).toList();
        break;
      }

      // 1. Shuffle and take the first n words
      candidates.shuffle(_random);
      selectedWords = candidates.take(count).toList();
      attempts++;

      // 2. Repeat if the selected list is not connected
    } while (!_isConnected(selectedWords));

    return selectedWords;
  }

  /// Checks if all words in a list share at least one letter connection
  /// to form a single "connected graph" (i.e., no island words).
  bool _isConnected(List<String> words) {
    if (words.isEmpty) return true;
    if (words.length == 1) return true;

    // We use a Breadth-First Search (BFS) approach.
    final visitedWords = <String>{};
    final queue = Queue<String>()
      // 1. Start traversal with the first word
      ..add(words.first);
    visitedWords.add(words.first);

    // 2. Process words in the queue
    while (queue.isNotEmpty) {
      final currentWord = queue.removeFirst();

      // Check all unvisited words to see if they connect to the current word
      for (final nextWord in words) {
        if (!visitedWords.contains(nextWord) &&
            _shareAnyLetter(currentWord, nextWord)) {
          visitedWords.add(nextWord);
          queue.add(nextWord);
        }
      }
    }

    // If the number of visited words equals the total number of words,
    // the graph is connected, and there are no island words.
    return visitedWords.length == words.length;
  }

  /// Helper to check if two words share at least one common character.
  bool _shareAnyLetter(String wordA, String wordB) {
    // Convert the shorter word to a Set for O(1) lookup
    final lettersA = wordA.split('').toSet();

    // Check if any letter in wordB is present in lettersA
    for (final charB in wordB.split('')) {
      if (lettersA.contains(charB)) {
        return true;
      }
    }
    return false;
  }

  int _calculateMaxLength(int levelNumber) {
    // Every 5 levels, allow one letter longer words
    // Starting with 4 letters at level 1
    // Level 1-5: 4 letters
    // Level 6-10: 5 letters
    // Level 11-15: 6 letters
    // etc.
    return 3 + ((levelNumber - 1) ~/ 5) + 1;
  }

  /// Loads the word list from the specified file.
  Future<void> loadWords() async {
    try {
      if (_loadAttempts < 10 && _words.isNotEmpty) {
        _loadAttempts++;
        return;
      }
      final wordList = await File(_wordListPath).readAsString();
      _words = wordList
          .split('\n')
          .where((w) => w.trim().isNotEmpty)
          .map((w) => w.trim().toUpperCase())
          .toList();
    } on Exception catch (_) {
      _words = [];
    }
  }
}
