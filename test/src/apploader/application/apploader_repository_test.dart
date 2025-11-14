import 'package:flutter_test/flutter_test.dart';
import 'package:level_data/level_data.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sozzle/src/apploader/application/apploader_repository.dart';
import 'package:sozzle/src/level/domain/i_level_repository.dart';
import 'package:sozzle/src/level/domain/level_data.dart';
import 'package:sozzle/src/settings/domain/i_setting_repository.dart';
import 'package:sozzle/src/settings/domain/settings.dart';
import 'package:sozzle/src/user_stats/domain/i_user_stats_repository.dart';

// mocks for test
class MockLevelRepo extends Mock implements ILevelRepository {}

class MockUserStatsRepo extends Mock implements IUserStatsRepository {}

class MockSettingsRepo extends Mock implements ISettingRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(const LevelData.empty());
  });

  group('Apploader', () {
    /// System Under Test
    late MockApploaderRepository sut;
    late ILevelRepository levelRepo;

    setUp(() {
      levelRepo = MockLevelRepo();
      final userStatsRepo = MockUserStatsRepo();
      final settingsRepo = MockSettingsRepo();
      sut = MockApploaderRepository(
        levelRepository: levelRepo,
        userStatsRepository: userStatsRepo,
        settingRepository: settingsRepo,
      );
    });

    tearDown(() {
      // nothing here yet
    });

    test('getLevels should return LevelList', () async {
      final tLevelData = [
        const LevelData.empty().copyWith(levelId: 1),
        const LevelData.empty().copyWith(levelId: 2),
      ];

      when(() => levelRepo.getLevels()).thenAnswer((_) async => tLevelData);
      final result = await sut.getLevels();
      expect(result, isA<LevelList>());
    });

    test('getLevels clears previous levels to prevent accumulation', () async {
      final tLevelData1 = [
        const LevelData.empty().copyWith(levelId: 1),
      ];
      final tLevelData2 = [
        const LevelData.empty().copyWith(levelId: 2),
      ];

      when(() => levelRepo.getLevels()).thenAnswer((_) async => tLevelData1);
      final result1 = await sut.getLevels();
      expect(result1.levels.length, equals(1));

      when(() => levelRepo.getLevels()).thenAnswer((_) async => tLevelData2);
      final result2 = await sut.getLevels();
      expect(result2.levels.length, equals(1));
      expect(result2.levels.first.levelId, equals(2));
    });

    test('saveData skips existing levels when writeToDisk is true', () async {
      final tLevelData = [
        const LevelData.empty().copyWith(levelId: 1),
        const LevelData.empty().copyWith(levelId: 2),
      ];

      when(() => levelRepo.getLevels()).thenAnswer((_) async => tLevelData);
      when(() => levelRepo.hasLevel(1)).thenAnswer((_) async => true);
      when(() => levelRepo.hasLevel(2)).thenAnswer((_) async => false);
      when(() => levelRepo.setLevel(any())).thenAnswer((_) async => true);

      await sut.getLevels();
      final progressStream = sut.saveData();
      await for (final _ in progressStream) {
        // Consume the stream
      }

      // Level 1 exists, so setLevel should not be called for it
      // Level 2 doesn't exist, so setLevel should be called once
      verify(() => levelRepo.hasLevel(1)).called(1);
      verify(() => levelRepo.hasLevel(2)).called(1);
      verify(() => levelRepo.setLevel(tLevelData[1])).called(1);
      verifyNever(() => levelRepo.setLevel(tLevelData[0]));
    });

    test('saveData does not write when writeToDisk is false', () async {
      final tLevelData = [
        const LevelData.empty().copyWith(levelId: 1),
        const LevelData.empty().copyWith(levelId: 2),
      ];

      when(() => levelRepo.getLevels()).thenAnswer((_) async => tLevelData);

      await sut.getLevels();
      final progressStream = sut.saveData(writeToDisk: false);
      await for (final _ in progressStream) {
        // Consume the stream
      }

      // No writes should happen
      verifyNever(() => levelRepo.hasLevel(any()));
      verifyNever(() => levelRepo.setLevel(any()));
    });

    test('getSetting should return Settings', () async {
      final settingsRepo = sut.settingRepository as MockSettingsRepo;
      when(settingsRepo.getSetting).thenAnswer(
        (_) => Future.value(
          const Settings(
            isDarkMode: false,
            isMusicOn: false,
            isSoundOn: false,
            isMute: true,
          ),
        ),
      );

      final result = await sut.getSetting();
      expect(result, isA<Settings>());
    });

    test('getSetting returns correct settings values', () async {
      final settingsRepo = sut.settingRepository as MockSettingsRepo;
      when(settingsRepo.getSetting).thenAnswer(
        (_) => Future.value(
          const Settings(
            isDarkMode: false,
            isMusicOn: false,
            isSoundOn: false,
            isMute: true,
          ),
        ),
      );

      final result = await sut.getSetting();
      expect(
        result,
        const Settings(
          isSoundOn: false,
          isMusicOn: false,
          isDarkMode: false,
          isMute: true,
        ),
      );
    });
  });
}
