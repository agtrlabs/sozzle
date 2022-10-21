import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:level_data/level_data.dart';
import 'package:level_generator/core/error/failure.dart';
import 'package:level_generator/core/usecases/use_case.dart';
import 'package:level_generator/src/rewards_generator/domain/repos/reward_repo.dart';

class GetRewards extends UseCaseWithParams<List<Reward>, GetRewardsParams> {
  final RewardRepo _rewardsRepo;

  GetRewards(this._rewardsRepo);

  /// Returns a list of rewards for the given level. If the level is null, it
  /// returns the rewards for the first level.
  /// The rewards should be generated based on the level.
  /// e.g if the level is above 10, the rewards should be more valuable than
  /// if the level is below 10.

  @override
  Future<Either<Failure, List<Reward>>?> call(GetRewardsParams params) async {
    return await _rewardsRepo.getRewards(params.levelId);
  }
}

class GetRewardsParams extends Equatable {
  const GetRewardsParams({required this.levelId});
  final int levelId;

  @override
  List<dynamic> get props => [levelId];
}
