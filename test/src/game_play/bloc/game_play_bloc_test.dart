import 'package:flutter_test/flutter_test.dart';
import 'package:sozzle/src/game_play/bloc/game_play_bloc.dart';
import 'package:sozzle/src/level/domain/level_data.dart';

LevelData levelData = LevelData(
  boardData: [],
  boardWidth: 5,
  boardHeight: 3,
  levelId: 1,
  words: ['TEST'],
);

void main() {
  group('GamePlayBloc', () {
    late GamePlayBloc bloc;

    setUp(() {
      bloc = GamePlayBloc(levelData: levelData);
    });

    tearDown(() async {
      await bloc.close();
    });

    test('Initial State test', () {
      expect(bloc.state, const GamePlayState(GamePlayActualState.allHidden));
    });
  });
}