import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

class LevelData extends Equatable{
  final int? levelId;
  final List<String>? words;
  final int? boardHeight;
  final int? boardWidth;
  final List<String>? boardData;

  const LevelData._({
    required this.levelId,
    required this.words,
    required this.boardWidth,
    required this.boardHeight,
    required this.boardData,
  });

  @override
  List<dynamic> get props => [
    levelId,
    words,
    boardHeight,
    boardWidth,
    boardData,
  ];

  static Future<String> _jsonLoader(String key) async {
    return await rootBundle.loadString(key);
  }
  /// Takes a dictionary and returns a LevelData object
  /// Don't use this for json files, if you have a json file, use the
  /// [LevelData.create()]
  LevelData.fromDictionary(Map<String, dynamic> dict):

      levelId = dict["levelId"],
      words = dict["words"],
      boardWidth = dict["boardWidth"],
      boardHeight = dict["boardHeight"],
      boardData = dict["boardData"];

  /// Accepts the path of the json file and returns a LevelData object
  /// Don't use this for raw HashMaps, if you have a hashmap, use the
  /// [LevelData.fromDictionary()]
  static Future<LevelData> create(String jsonPath) async {

    Map<String, dynamic> data = jsonDecode(await _jsonLoader(jsonPath)) as Map<String, dynamic>;
    return LevelData._(
      levelId: data["levelId"] as int,
      words: List<String>.from(data["words"]),
      boardWidth: data["boardWidth"] as int,
      boardHeight: data["boardHeight"] as int,
      boardData: List<String>.from(data["boardData"])
    );
  }
}
