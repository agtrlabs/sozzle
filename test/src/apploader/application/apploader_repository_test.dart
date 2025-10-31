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
  // setUpAll(() {
  //   registerFallbackValue(Uri.parse('https://cexample.com/api'));
  // });

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

    test('getSetting should return Settings', () async {
      when(() => sut.getSetting()).thenAnswer(
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

    test('getLevels should return LevelList', () async {
      when(() => sut.getSetting()).thenAnswer(
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
