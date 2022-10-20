import 'package:dartz/dartz.dart';
import 'package:level_generator/core/error/failure.dart';

import '../entities/reward.dart';
import '../repos/reward_repo.dart';

class GetRewards {
  final RewardRepo _rewardsRepo;

  GetRewards(this._rewardsRepo);

  /// Returns a list of rewards for the given level. If the level is null, it
  /// returns the rewards for the first level.
  /// The rewards should be generated based on the level.
  /// e.g if the level is above 10, the rewards should be more valuable than
  /// if the level is below 10.
  Future<Either<Failure, List<Reward>>?> call(int? levelId) async {
    return await _rewardsRepo.getRewards(levelId);
  }
}
