import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:level_data/src/reward_base.dart';

/// A model representing the data of a level in the game
class LevelData extends Equatable {
  /// Creates a [LevelData] instance
  const LevelData({
    required this.levelId,
    required this.words,
    required this.boardWidth,
    required this.boardHeight,
    required this.boardData,
    this.rewards = const [],
  });

  LevelData.empty()
      : levelId = 0,
        words = const [],
        boardWidth = 0,
        boardHeight = 0,
        boardData = const [],
        rewards = const [];
  /// Creates an empty [LevelData] instance

  /// Creates a [LevelData] instance from a JSON string
  factory LevelData.fromJson(String json) =>
      LevelData.fromMap(jsonDecode(json) as Map<String, dynamic>);

  /// Creates a [LevelData] instance from a map
  factory LevelData.fromMap(Map<String, dynamic> json) => LevelData(
        levelId: json['id'] as int,
        boardHeight: json['rows'] as int,
        boardWidth: json['cols'] as int,
        boardData: List<String>.from(json['board'] as List<dynamic>),
        words: List<String>.from(json['words'] as List<dynamic>),
        rewards: List<String>.from((json['rewards'] as List<dynamic>)).map((e) {
          return Reward.fromJson(e);
        }).toList(),
      );

  static const _levelPoint = 50;

  /// The points gained from this level
  static int get levelPoint => _levelPoint;

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


  /// Converts the [LevelData] instance to a map
  Map<String, dynamic> toMap() => {
        'id': levelId,
        'board': boardData,
        'words': words,
        'rows': boardHeight,
        'cols': boardWidth,
        'rewards': rewards.map((e) => e.toJson()).toList(),
      };

  /// Converts the [LevelData] instance to a JSON string
  String toJson() => json.encode(toMap());

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
  bool get stringify => true;

  /// Creates a copy of the current [LevelData] with optional new values
  LevelData copyWith({
    int? levelId,
    List<String>? words,
    int? boardHeight,
    int? boardWidth,
    List<String>? boardData,
    List<Reward>? rewards,
  }) {
    return LevelData(
      levelId: levelId ?? this.levelId,
      words: words ?? this.words,
      boardHeight: boardHeight ?? this.boardHeight,
      boardWidth: boardWidth ?? this.boardWidth,
      boardData: boardData ?? this.boardData,
      rewards: rewards ?? this.rewards,
    );
  }
}
