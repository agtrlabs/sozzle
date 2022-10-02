import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sozzle/src/apploader/apploader.dart';
import 'package:sozzle/src/level/domain/level_data.dart';
import 'package:sozzle/src/user_stats/domain/user_progress_data.dart';

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
      when(() => appLoaderRepo.saveData())
          .thenAnswer((_) => Stream.fromIterable([0, 0.4, 0.6, 0.8, 1]));
    });

    tearDown(() async {
      await apploader.close();
    });

    test('Initial State test', () {
      expect(apploader.state, const ApploaderState(LoaderState.initial));
    });

    blocTest<ApploaderCubit, ApploaderState>(
      'should getUserProgressData after loading levels()',
      build: () => apploader,
      act: (bloc) => bloc.updatePuzzleData(),
      verify: (bloc) =>
          verify(() => appLoaderRepo.getUserProgressData()).called(1),
    );

    blocTest<ApploaderCubit, ApploaderState>(
      'should call AppLoaderRepository.getLevels() on startup',
      build: () => apploader,
      act: (bloc) => bloc.updatePuzzleData(),
      verify: (bloc) => verify(() => appLoaderRepo.getLevels()).called(1),
    );
  });
}
