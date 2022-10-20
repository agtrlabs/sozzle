import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/level_data.dart';
import '../repos/level_generator_repo.dart';

class GenerateLevel {
  final LevelGeneratorRepo repo;
  const GenerateLevel(this.repo);

  Future<Either<Failure, LevelData>?> exec() async =>
      await repo.generateLevel();
}
