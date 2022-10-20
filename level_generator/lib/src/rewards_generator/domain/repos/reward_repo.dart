import 'package:dartz/dartz.dart';
import 'package:level_data/level_data.dart';
import 'package:level_generator/core/error/failure.dart';

abstract class RewardRepo {
  Future<Either<Failure, List<Reward>>>? getRewards(int? levelId);
}
