import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sozzle/src/user_stats/user_stats.dart';

class MockUserStatsRepo extends Mock implements IUserStatsRepository {}

void main() {
  group('UserStatsCubit', () {
    late UserStatsCubit userStatsCubit;
    late MockUserStatsRepo repo;

    setUpAll(() {
      registerFallbackValue(UserProgressData(currentLevel: 1));
    });

    setUp(() {
      repo = MockUserStatsRepo();
      userStatsCubit = UserStatsCubit(repo);
    });
    tearDown(() {
      userStatsCubit.close();
    });
    test('should call IUserStatsRepository.getCurrent', () async {
      when(() => repo.getCurrent()).thenAnswer(
        (_) async => UserProgressData(currentLevel: 1),
      );
      userStatsCubit.readCurrentStats();
      verify(() => repo.getCurrent()).called(1);
    });

    test('on levelUp save progress', () async {
      when(() => repo.save(any())).thenAnswer((_) async {
        return;
      });
      final currentPoints = userStatsCubit.state.progress.points;
      userStatsCubit.advanceLevelUp();
      verify(() => repo.save(any())).called(1);
      expect(userStatsCubit.state.progress.points, equals(currentPoints + 10));
    });
  });
}
