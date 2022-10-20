import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/reward.dart';

abstract class RewardRepo {
  Future<Either<Failure, List<Reward>>>? getRewards(int? levelId);
}
