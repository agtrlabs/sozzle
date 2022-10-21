import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:level_data/level_data.dart';
import 'package:level_generator/core/error/failure.dart';
import 'package:level_generator/core/usecases/use_case.dart';
import 'package:level_generator/src/level_generator/domain/repos/level_generator_repo.dart';

class GenerateLevelFromJsonFile
    implements UseCaseWithParams<LevelData, GenerateLevelFromFileParams> {
  final LevelGeneratorRepo repo;
  GenerateLevelFromJsonFile(this.repo);

  @override
  Future<Either<Failure, LevelData>?> call(
          GenerateLevelFromFileParams? params) async =>
      await repo.generateLevelFromJsonFile(params?.path);
}

class GenerateLevelFromFileParams extends Equatable {
  final String path;
  const GenerateLevelFromFileParams({required this.path});

  @override
  List<dynamic> get props => [path];
}
