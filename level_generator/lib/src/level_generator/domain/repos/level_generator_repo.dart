
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/level_data.dart';

abstract class LevelGeneratorRepo {
  Future<Either<Failure, LevelData>>? generateLevel();
}