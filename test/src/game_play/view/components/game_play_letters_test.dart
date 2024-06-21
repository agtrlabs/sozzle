import 'package:flutter_test/flutter_test.dart';
import 'package:level_data/level_data.dart';
import 'package:sozzle/src/game_play/game_play.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('GamePlayLetters', () {
    testWidgets(
      'should render [GamePlayLetters]',
      (tester) async {
        await tester.pumpApp(GamePlayLetters(LevelData.empty()));

        expect(find.byType(GamePlayLetters), findsOneWidget);
      },
    );
  });
}
