import 'package:dartz/dartz.dart';
import 'package:level_data/level_data.dart';
import 'package:level_generator/core/error/failure.dart';




abstract class LevelGeneratorRepo {

  // TODO: implement this method
  //  static Future<String> _jsonLoader(String key) async {
  //     return await rootBundle.loadString(key);
  //   }

  /// Takes a dictionary and returns a LevelData object
  /// Don't use this for json files, if you have a json file, use the
  /// [GenerateLeveLFromJsonFile]
  ///
  /// return LevelData(
  ///         levelId: dict["levelId"] as int,
  ///         words: dict["words"] as List<String>,
  ///         boardWidth: dict["boardWidth"] as int,
  ///         boardHeight: dict["boardHeight"] as int,
  ///         boardData: dict["boardData"] as List<String>,
  ///         rewards: dict["rewards"]
  ///     );
  Future<Either<Failure, LevelData>>? generateLevelFromDict(Map<String, dynamic>? dict);


  /// Accepts the path of the json file and returns a LevelData object
  /// Don't use this for raw HashMaps, if you have a hashmap, use the
  /// [GenerateLevelFromDict]
  ///
  /// final data =
  ///         jsonDecode(await _jsonLoader(jsonPath)) as Map<String, dynamic>;
  ///
  ///     return LevelData(
  ///         levelId: data["levelId"] as int,
  ///         words: List<String>.from(data["words"]),
  ///         boardWidth: data["boardWidth"] as int,
  ///         boardHeight: data["boardHeight"] as int,
  ///         boardData: List<String>.from(data["boardData"]),
  ///         rewards: data["rewards"]
  ///     );
  Future<Either<Failure, LevelData>>? generateLevelFromJsonFile(String? jsonPath);

}
