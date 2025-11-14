/// Configuration for the game difficulty
class DifficultyConfig {
  /// Configuration for the game difficulty
  const DifficultyConfig({
    required this.minWordLength,
    required this.maxWordLength,
    required this.minWordsPerLevel,
    required this.maxWordsPerLevel,
    required this.minDifficulty,
    required this.maxDifficulty,
    this.timeLimit = 0,
    this.pointsPerWord = 100,
    this.baseGridSize = 8,
  }) : difficulty = minWordLength <= 3
           ? 'easy'
           : minWordLength <= 4
           ? 'medium'
           : 'hard';

  /// Create a config for easy difficulty
  factory DifficultyConfig.easy() {
    return const DifficultyConfig(
      minWordLength: 3,
      maxWordLength: 5,
      minWordsPerLevel: 3,
      maxWordsPerLevel: 5,
      minDifficulty: 0,
      maxDifficulty: 2,
      baseGridSize: 6,
    );
  }

  /// Create a config for medium difficulty
  factory DifficultyConfig.medium() {
    return const DifficultyConfig(
      minWordLength: 4,
      maxWordLength: 6,
      minWordsPerLevel: 4,
      maxWordsPerLevel: 7,
      minDifficulty: 1,
      maxDifficulty: 3,
      timeLimit: 300,
      // 5 minutes
      pointsPerWord: 150,
    );
  }

  /// Create a config for hard difficulty
  factory DifficultyConfig.hard() {
    return const DifficultyConfig(
      minWordLength: 5,
      maxWordLength: 8,
      minWordsPerLevel: 5,
      maxWordsPerLevel: 8,
      minDifficulty: 2,
      maxDifficulty: 5,
      timeLimit: 180,
      // 3 minutes
      baseGridSize: 10,
      pointsPerWord: 200,
    );
  }

  /// The minimum length of words to use
  final int minWordLength;

  /// The maximum length of words to use
  final int maxWordLength;

  /// The minimum number of words per level
  final int minWordsPerLevel;

  /// The maximum number of words per level
  final int maxWordsPerLevel;

  /// The minimum difficulty of words (0-5)
  final int minDifficulty;

  /// The maximum difficulty of words (0-5)
  final int maxDifficulty;

  /// Time limit in seconds (0 means no limit)
  final int timeLimit;

  /// Points awarded per word found
  final int pointsPerWord;

  /// Base size of the grid (width and height)
  final int baseGridSize;

  /// The difficulty level as a string
  final String difficulty;

  /// Create a copy with some fields replaced
  DifficultyConfig copyWith({
    int? minWordLength,
    int? maxWordLength,
    int? minWordsPerLevel,
    int? maxWordsPerLevel,
    int? minDifficulty,
    int? maxDifficulty,
    int? timeLimit,
    int? pointsPerWord,
    int? baseGridSize,
  }) {
    return DifficultyConfig(
      minWordLength: minWordLength ?? this.minWordLength,
      maxWordLength: maxWordLength ?? this.maxWordLength,
      minWordsPerLevel: minWordsPerLevel ?? this.minWordsPerLevel,
      maxWordsPerLevel: maxWordsPerLevel ?? this.maxWordsPerLevel,
      minDifficulty: minDifficulty ?? this.minDifficulty,
      maxDifficulty: maxDifficulty ?? this.maxDifficulty,
      timeLimit: timeLimit ?? this.timeLimit,
      pointsPerWord: pointsPerWord ?? this.pointsPerWord,
      baseGridSize: baseGridSize ?? this.baseGridSize,
    );
  }
}
