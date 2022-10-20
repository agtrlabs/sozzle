import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_data/level_data.dart';
import 'package:level_generator/src/level_generator/domain/repos/level_generator_repo.dart';
import 'package:level_generator/src/level_generator/domain/usecases/generate_level_from_dict.dart';
import 'package:mocktail/mocktail.dart';

class MockLevelGeneratorRepo extends Mock implements LevelGeneratorRepo {}

void main() {
  late MockLevelGeneratorRepo repo;
  late GenerateLevelFromDict useCase;

  setUp(() {
    repo = MockLevelGeneratorRepo();
    useCase = GenerateLevelFromDict(repo);
  });

  final testDictionary = {
    "levelId": 1,
    "words": ["SAW", "WASP"],
    "boardHeight": 5,
    "boardWidth": 5,
    "boardData": ["W", "S", ""],
    "rewards": [
      {
        "id": 1,
        "name": "Test Badge",
        "description": "Test Badge Description",
        "image": "Test Badge Image",
        "points": 50,
      },
      {
        "id": 2,
        "name": "Test Coin",
        "description": "Test Coin Description",
        "image": "Test Coin Image",
        "points": 500,
      },
    ],
  };

  const testLevelData = LevelData(
      levelId: 1,
      words: ["SAW", "WASP"],
      boardHeight: 5,
      boardWidth: 5,
      boardData: ["W", "S", ""],
      rewards: [
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
          points: 500,
        ),
      ]);

  test("generate level data from dictionary", () async {
    when(() => repo.generateLevelFromDict(any()))
        .thenAnswer((_) async => const Right(testLevelData));

    final result =
        await useCase(GenerateLevelFromDictParams(dictionary: testDictionary));

    expect(result, const Right(testLevelData));

    verify(() => repo.generateLevelFromDict(testDictionary));
    verifyNoMoreInteractions(repo);
  });
}
