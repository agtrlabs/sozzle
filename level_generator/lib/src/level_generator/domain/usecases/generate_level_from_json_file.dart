

import 'package:dartz/dartz.dart';
import 'package:level_data/level_data.dart';
import 'package:level_generator/core/error/failure.dart';
import 'package:level_generator/src/level_generator/domain/repos/level_generator_repo.dart';

class GenerateLevelFromJsonFile {
  final LevelGeneratorRepo repo;
  GenerateLevelFromJsonFile(this.repo);

  Future<Either<Failure, LevelData>?> exec(String? jsonPath) async =>
      await repo.generateLevelFromJsonFile(jsonPath);
}