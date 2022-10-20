import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_generator/src/level_generator/domain/entities/reward.dart';
import 'package:level_generator/src/level_generator/domain/repos/reward_repo.dart';
import 'package:level_generator/src/level_generator/domain/usecases/get_rewards.dart';
import 'package:mocktail/mocktail.dart';

class MockRewardRepo extends Mock implements RewardRepo {}

void main() {
  late MockRewardRepo repo;
  late GetRewards useCase;

  setUp(() {
    repo = MockRewardRepo();
    useCase = GetRewards(repo);
  });

  const testLevel = 1;
  const testRewards = [
    Badge(
      id: 1,
      name: "Test Badge",
      description: "Test Badge Description",
      image: "Test Badge Image",
      points: 50,
    ),
    RewardCoin(
      id: 2,
      name: "Test Coin",
      description: "Test Coin Description",
      image: "Test Coin Image",
      points: 100,
    ),
  ];

  test('get rewards', () async {
    when(() => repo.getRewards(any()))
        .thenAnswer((_) async => const Right(testRewards));

    final result = await useCase.call(testLevel);

    expect(result, const Right(testRewards));
    verify(() => repo.getRewards(testLevel));
    verifyNoMoreInteractions(repo);
  });
}
