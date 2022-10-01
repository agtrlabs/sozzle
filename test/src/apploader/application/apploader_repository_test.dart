import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sozzle/src/apploader/application/apploader_repository.dart';
import 'package:sozzle/src/level/domain/i_level_repository.dart';
import 'package:sozzle/src/level/domain/level_data.dart';
import 'package:sozzle/src/user_stats/domain/i_user_stats_repository.dart';

// mocks for test
class MockLevelRepo extends Mock implements ILevelRepository {}

class MockUserStatsRepo extends Mock implements IUserStatsRepository {}

void main() {
  // setUpAll(() {
  //   registerFallbackValue(Uri.parse('https://cexample.com/api'));
  // });

  group('Apploader', () {
    /// System Under Test
    late MockApploaderRepository sut;

    setUp(() {
      final levelRepo = MockLevelRepo();
      final userStatsRepo = MockUserStatsRepo();
      sut = MockApploaderRepository(
        levelRepository: levelRepo,
        userStatsRepository: userStatsRepo,
      );
    });

    tearDown(() {
      // nothing here yet
    });

    test('getLevels should return LevelList', () async {
      final result = await sut.getLevels();
      expect(result, isA<LevelList>());
    });
  });
}
