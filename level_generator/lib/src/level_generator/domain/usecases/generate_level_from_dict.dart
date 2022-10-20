import 'package:dartz/dartz.dart';
import 'package:level_data/level_data.dart';
import 'package:level_generator/core/error/failure.dart';
import 'package:level_generator/src/level_generator/domain/repos/level_generator_repo.dart';

class GenerateLevelFromDict {
  final LevelGeneratorRepo repo;
  const GenerateLevelFromDict(this.repo);

  Future<Either<Failure, LevelData>?> exec(Map<String, dynamic>? dict) async =>
      await repo.generateLevelFromDict(dict);
}
