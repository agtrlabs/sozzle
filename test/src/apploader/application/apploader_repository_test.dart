import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sozzle/src/apploader/application/apploader_repository.dart';
import 'package:sozzle/src/level/domain/i_level_repository.dart';
import 'package:sozzle/src/level/domain/level_data.dart';

// mocks for test
class MockLevelRepo extends Mock implements ILevelRepository {}

void main() {
  // setUpAll(() {
  //   registerFallbackValue(Uri.parse('https://cexample.com/api'));
  // });

  group('Apploader', () {
    /// System Under Test
    late MockApploaderRepository sut;

    setUp(() {
      final levelRepo = MockLevelRepo();
      sut = MockApploaderRepository(levelRepo);
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
