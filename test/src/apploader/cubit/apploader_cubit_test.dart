import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sozzle/src/level/domain/level_data.dart';
import 'package:sozzle/src/level/domain/user_progress_data.dart';
import 'package:sozzle/src/apploader/apploader.dart';

/// mock loader for test
class MockAppLoaderRepo extends Mock implements IApploaderRepository {}

void main() {
  group('ApploaderCubit', () {
    late ApploaderCubit apploader;
    late MockAppLoaderRepo appLoaderRepo;

    setUp(() {
      appLoaderRepo = MockAppLoaderRepo();
      apploader = ApploaderCubit(apploaderRepository: appLoaderRepo);

      when(() => appLoaderRepo.getLevels()).thenAnswer(
        (_) async => LevelList([]),
      );
      when(() => appLoaderRepo.getUserProgressData())
          .thenAnswer((invocation) async => UserProgressData(currentLevel: 1));
    });

    tearDown(() async {
      await apploader.close();
    });

    test('Initial State test', () {
      expect(apploader.state, const ApploaderState(LoaderState.initial));
    });

    test('should call AppLoaderRepository.getLevels() on startup', () async {
      await apploader.updatePuzzleData();

      /// delay to finish apploader
      await Future.delayed(const Duration(seconds: 10), () {});
      verify(() => appLoaderRepo.getLevels()).called(1);
    });
    test('should getUserProgressData after loading levels()', () async {
      await apploader.updatePuzzleData();
      verify(() => appLoaderRepo.getUserProgressData()).called(1);
    });
  });
}
