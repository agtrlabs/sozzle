import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:level_data/level_data.dart';
import 'package:level_generator/core/error/failure.dart';
import 'package:level_generator/core/usecases/use_case.dart';
import 'package:level_generator/src/level_generator/domain/repos/level_generator_repo.dart';

class GenerateLevelFromDict
    implements UseCaseWithParams<LevelData, GenerateLevelFromDictParams> {
  final LevelGeneratorRepo repo;
  const GenerateLevelFromDict(this.repo);

  @override
  Future<Either<Failure, LevelData>?> call(
          GenerateLevelFromDictParams? params) async =>
      await repo.generateLevelFromDict(params?.dictionary);
}

class GenerateLevelFromDictParams extends Equatable {
  final Map<String, dynamic> dictionary;
  const GenerateLevelFromDictParams({required this.dictionary});

  @override
  List<dynamic> get props => [dictionary];
}
