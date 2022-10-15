

import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_generator/src/level_generator/domain/entities/level_data.dart';
import 'package:level_generator/src/level_generator/domain/repos/level_generator_repo.dart';
import 'package:level_generator/src/level_generator/domain/usecases/generate_level.dart';
import 'package:mocktail/mocktail.dart';

class MockLevelGeneratorRepo extends Mock implements LevelGeneratorRepo {}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  late GenerateLevel useCase;
  late MockLevelGeneratorRepo mockLevelGeneratorRepo;
  setUp(() {
    mockLevelGeneratorRepo = MockLevelGeneratorRepo();
    useCase = GenerateLevel(mockLevelGeneratorRepo);
  });

  final Map<String, dynamic> testDict = {
    "levelId": 1,
    "words": ["SAW", "WASP"],
    "boardHeight": 5,
    "boardWidth": 5,
    "boardData": ["W", "S", ""]
  };

  final LevelData testLevelData = LevelData.fromDictionary(testDict);
  final LevelData testLevelDataFromJson = await LevelData.create("assets/level_test.json");

  group("Generate Level", () {
    test("from dictionary", () async{
      when(() => mockLevelGeneratorRepo.generateLevel()).thenAnswer((_) async => Right(testLevelData));

      final result = await useCase.exec();

      expect(result, Right(testLevelData));
      verify(mockLevelGeneratorRepo.generateLevel);
      verifyNoMoreInteractions(mockLevelGeneratorRepo);
    });

    test("from json file", () async {
      when(() => mockLevelGeneratorRepo.generateLevel()).thenAnswer((_) async => Right(testLevelDataFromJson));

      final result = await useCase.exec();

      expect(result, Right(testLevelDataFromJson));
      verify(mockLevelGeneratorRepo.generateLevel);
      verifyNoMoreInteractions(mockLevelGeneratorRepo);
    });
  });
}