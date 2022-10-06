import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sozzle/src/game_play/view/view.dart';
import 'package:sozzle/src/level/domain/i_level_repository.dart';
import '../../../helpers/helpers.dart';

class MockLevelRepository extends Mock implements ILevelRepository {}

void main() {
  group('App', () {
    setUp(() async {
      //TODO:  setup Mock Bloc
    });
    testWidgets('should have a FutureBuilder', (WidgetTester tester) async {
      await tester.pumpApp(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<ILevelRepository>(
              create: (context) => MockLevelRepository(),
            ),
          ],
          child: const GamePlayPage(
            levelID: 1,
          ),
        ),
      );
      // TODO: add mock behaviour
      await tester.pump();
      final futureFinder = find.byElementType(FutureBuilder);
      expect(futureFinder, findsOneWidget);
    });
    
  });
}
