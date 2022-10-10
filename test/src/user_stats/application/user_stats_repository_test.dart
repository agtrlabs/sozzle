import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sozzle/src/user_stats/application/user_stats_repository.dart';
import 'package:sozzle/src/user_stats/domain/user_progress_data.dart';

class MockUserProgressData extends Mock implements UserProgressData {}

void main() {
  group('UserStatsRepository', () {
    test('convert  progressdata.toMap and save ', () async {
      final data = MockUserProgressData();
      final repo = UserStatsRepository();
      when(data.toMap).thenReturn({'currentLevel': 1});

      await repo.save(data);

      verify(data.toMap).called(1);
    });
  });
}
