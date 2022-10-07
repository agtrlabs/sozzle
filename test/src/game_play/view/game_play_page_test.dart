import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sozzle/src/game_play/view/view.dart';
import 'package:sozzle/src/level/domain/i_level_repository.dart';
import 'package:sozzle/src/level/domain/level_data.dart';
import '../../../helpers/helpers.dart';

class MockLevelRepository extends Mock implements ILevelRepository {}

void main() {
  group('GamePlayPage', () {
    late MockLevelRepository repo;
    setUp(() async {
      repo = MockLevelRepository();
    });
    testWidgets('should have a FutureBuilder', (WidgetTester tester) async {
      when(() => repo.getLevel(any())).thenAnswer(
        (_) async => LevelData(
          boardData: [],
          boardWidth: 1,
          boardHeight: 1,
          levelId: 1,
          words: [],
        ),
      );
      await tester.pumpApp(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<ILevelRepository>(
              create: (context) => repo,
            ),
          ],
          child: const GamePlayPage(
            levelID: 1,
          ),
        ),
      );
      await tester.pump();
      final futureFinder = find.byType(FutureBuilder<LevelData>);
      expect(futureFinder, findsOneWidget);
    });
  });
}
