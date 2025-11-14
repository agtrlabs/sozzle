import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localstore/localstore.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sozzle/src/game_play/domain/entities/booster.dart';
import 'package:sozzle/src/user_stats/application/user_stats_repository.dart';
import 'package:sozzle/src/user_stats/domain/user_progress_data.dart';

class MockUserProgressData extends Mock implements UserProgressData {}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  group('UserStatsRepository', () {
    late UserStatsRepository repo;
    final db = Localstore.instance;

    setUp(() async {
      repo = UserStatsRepository();
      // Clean up before each test
      await db.collection('stats').doc('current').delete();
    });

    tearDown(() async {
      // Clean up after each test
      await db.collection('stats').doc('current').delete();
    });

    test('convert  progressdata.toMap and save ', () async {
      final data = MockUserProgressData();
      when(data.toMap).thenReturn({'currentLevel': 1});

      await repo.save(data);

      verify(data.toMap).called(1);
    });

    test('getCurrent persists saved progress across sessions', () async {
      // Arrange: Save progress with level, points, and boosters
      final savedProgress = UserProgressData(
        currentLevel: 5,
        points: 7500,
        boosters: [const UseAHint(boosterCount: 3)],
      );
      await repo.save(savedProgress);

      // Act: Load the progress (simulating a new session)
      final loadedProgress = await repo.getCurrent();

      // Assert: All progress data should be preserved
      expect(loadedProgress.currentLevel, equals(5));
      expect(loadedProgress.points, equals(7500));
      expect(loadedProgress.boosters.length, equals(1));
      expect(
        loadedProgress.boosters.whereType<UseAHint>().first.boosterCount,
        equals(3),
      );
    });

    test('getCurrent creates initial progress when no data exists', () async {
      // Act: Load progress when nothing is saved
      final loadedProgress = await repo.getCurrent();

      // Assert: Should create initial progress at level 1
      expect(loadedProgress.currentLevel, equals(1));
      expect(loadedProgress.points, greaterThanOrEqualTo(0));
    });
  });
}
