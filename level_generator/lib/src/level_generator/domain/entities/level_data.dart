import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:level_generator/src/level_generator/domain/entities/reward.dart';

class LevelData extends Equatable {
  static const _levelPoint = 50;
  static get levelPoint => _levelPoint;

  final int? levelId;
  final List<String>? words;
  final int? boardHeight;
  final int? boardWidth;
  final List<String>? boardData;
  final List<Reward> rewards;

  LevelData._({
    required this.levelId,
    required this.words,
    required this.boardWidth,
    required this.boardHeight,
    required this.boardData,
  }) : rewards = [
          const RewardCoin(
            name: 'Coin',
            description: 'Coin',
            image: 'assets/images/coin.png',
            points: 10,
            id: 1,
          ),
          const Badge(
            name: 'Veteran',
            description: 'Veteran',
            image: 'assets/images/badge.png',
            points: 100,
            id: 2,
          ),
        ];

  @override
  List<dynamic> get props => [
        levelId,
        words,
        boardHeight,
        boardWidth,
        boardData,
        rewards,
      ];

  static Future<String> _jsonLoader(String key) async {
    return await rootBundle.loadString(key);
  }

  /// Takes a dictionary and returns a LevelData object
  /// Don't use this for json files, if you have a json file, use the
  /// [LevelData.create()]
  LevelData.fromDictionary(Map<String, dynamic> dict)
      : levelId = dict["levelId"],
        words = dict["words"],
        boardWidth = dict["boardWidth"],
        boardHeight = dict["boardHeight"],
        boardData = dict["boardData"],
        rewards = [];

  /// Accepts the path of the json file and returns a LevelData object
  /// Don't use this for raw HashMaps, if you have a hashmap, use the
  /// [LevelData.fromDictionary()]
  static Future<LevelData> create(String jsonPath) async {
    Map<String, dynamic> data =
        jsonDecode(await _jsonLoader(jsonPath)) as Map<String, dynamic>;
    return LevelData._(
        levelId: data["levelId"] as int,
        words: List<String>.from(data["words"]),
        boardWidth: data["boardWidth"] as int,
        boardHeight: data["boardHeight"] as int,
        boardData: List<String>.from(data["boardData"]));
  }
}
