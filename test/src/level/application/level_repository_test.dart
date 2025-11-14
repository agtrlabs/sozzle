import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_data/level_data.dart';
import 'package:level_generator/level_generator.dart';
import 'package:localstore/localstore.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sozzle/src/level/application/level_repository.dart';

class MockLevelGenerator extends Mock implements LevelGenerator {}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  group('LevelRepository', () {
    late LevelRepository repo;
    late LevelGenerator mockGenerator;
    final db = Localstore.instance;

    setUp(() async {
      mockGenerator = MockLevelGenerator();
      repo = LevelRepository(levelGenerator: mockGenerator);
      // Clean up before each test
      await db.collection('levels').delete();
    });

    tearDown(() async {
      // Clean up after each test
      await db.collection('levels').delete();
    });

    group('hasLevel', () {
      test('returns true when level exists', () async {
        // Arrange: Save a level
        final level = const LevelData.empty().copyWith(levelId: 1);
        await repo.setLevel(level);

        // Act
        final result = await repo.hasLevel(1);

        // Assert
        expect(result, isTrue);
      });

      test('returns false when level does not exist', () async {
        // Act
        final result = await repo.hasLevel(999);

        // Assert
        expect(result, isFalse);
      });

      test('returns true for multiple saved levels', () async {
        // Arrange: Save multiple levels
        final level1 = const LevelData.empty().copyWith(levelId: 1);
        final level2 = const LevelData.empty().copyWith(levelId: 2);
        final level3 = const LevelData.empty().copyWith(levelId: 3);
        await repo.setLevel(level1);
        await repo.setLevel(level2);
        await repo.setLevel(level3);

        // Act & Assert
        expect(await repo.hasLevel(1), isTrue);
        expect(await repo.hasLevel(2), isTrue);
        expect(await repo.hasLevel(3), isTrue);
        expect(await repo.hasLevel(4), isFalse);
      });
    });

    group('setLevel and getLevel', () {
      test('saves and retrieves level correctly', () async {
        // Arrange
        final level = const LevelData.empty().copyWith(
          levelId: 5,
          words: ['TEST', 'WORD'],
        );

        // Act
        await repo.setLevel(level);
        final retrieved = await repo.getLevel(5);

        // Assert
        expect(retrieved.levelId, equals(5));
        expect(retrieved.words, equals(['TEST', 'WORD']));
      });

      test('generates level if not found', () async {
        // Arrange
        final generatedLevel = const LevelData.empty().copyWith(
          levelId: 10,
          words: ['GENERATED'],
        );
        when(() => mockGenerator.generateLevel(level: 10))
            .thenAnswer((_) async => generatedLevel);

        // Act
        final result = await repo.getLevel(10);

        // Assert
        expect(result.levelId, equals(10));
        expect(result.words, equals(['GENERATED']));
        verify(() => mockGenerator.generateLevel(level: 10)).called(1);
      });
    });
  });
}
