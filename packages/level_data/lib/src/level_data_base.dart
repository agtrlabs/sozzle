import 'package:equatable/equatable.dart';
import 'package:level_data/src/reward_base.dart';

class LevelData extends Equatable {
  const LevelData({
    required this.levelId,
    required this.words,
    required this.boardWidth,
    required this.boardHeight,
    required this.boardData,
    this.rewards = const [],
  });

  factory LevelData.fromMap(Map<String, dynamic> json) => LevelData(
        levelId: json['id'] as int,
        boardHeight: json['rows'] as int,
        boardWidth: json['cols'] as int,
        boardData: List<String>.from(
          (json['board'] as List<dynamic>).map<String>((x) => x.toString()),
        ),
        words: List<String>.from(
          (json['words'] as List<dynamic>).map<String>((x) => x.toString()),
        ),
        rewards: List<Reward>.from((json['rewards'] as List<dynamic>)
            .map<Reward>((x) => Reward.fromMap(x))),
      );

  static const _levelPoint = 50;

  /// The points gained from this level
  static get levelPoint => _levelPoint;

  /// level id
  final int levelId;

  /// hidden goal words of the level
  final List<String> words;

  /// Count of Rows
  final int boardHeight;

  /// Count of columns
  final int boardWidth;

  /// The data required to draw puzzle board
  ///
  /// Indexing starts from Top to Down.
  ///
  /// A 3x3 grid example boardData can be:
  ///
  /// ```dart
  /// boardData = ['0', '1', '2', '3', '4', '5', '6', '7', '8'];
  /// ```
  ///
  /// The boardData will represent a grid as:
  ///
  /// | 0 | 3 | 6 |
  /// | --|---|-- |
  /// | 1 | 4 | 7 |
  /// | 2 | 5 | 8 |
  ///
  final List<String> boardData;

  /// The rewards gained from this level
  final List<Reward> rewards;

  Map<String, dynamic> toMap() => {
        'id': levelId,
        'board': List<dynamic>.from(boardData.map((x) => x)),
        'words': List<dynamic>.from(words.map((x) => x)),
        'rows': boardHeight,
        'cols': boardWidth,
        'rewards': List<dynamic>.from(rewards.map((x) => x.toMap())),
      };

  @override
  List<dynamic> get props => [
        levelId,
        words,
        boardHeight,
        boardWidth,
        boardData,
        rewards,
      ];

  @override
  String toString() => '''LevelData(
        levelId: $levelId,
        words: $words,
        boardHeight: $boardHeight,
        boardWidth: $boardWidth,
        boardData: $boardData,
        rewards: $rewards,
  );''';
}
