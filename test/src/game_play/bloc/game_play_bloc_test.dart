import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sozzle/src/game_play/bloc/game_play_bloc.dart';
import 'package:sozzle/src/level/domain/level_data.dart';

/*
EXIST
    E
    S
    T
*/
LevelData levelData = LevelData(
  boardData: [
    ...'     '.split(''),
    ...'EXIST'.split(''),
    ...'    E'.split(''),
    ...'    S'.split(''),
    ...'    T'.split(''),
  ],
  boardWidth: 5,
  boardHeight: 5,
  levelId: 1,
  words: ['EXIST', 'TEST'],
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

    blocTest<GamePlayBloc, GamePlayState>(
      'emits state notFound if word does not exist',
      build: () => bloc,
      act: (bloc) => bloc.add(GamePlayEventInputWord('NOTEXIST')),
      expect: () => [const GamePlayState(GamePlayActualState.notFound)],
      //verify: (e) => expect(e.state.state, GamePlayActualState.notFound),
    );

    blocTest<GamePlayBloc, GamePlayState>(
      'emits state wordFound with cell List, if word exists left to right',
      build: () => bloc,
      act: (bloc) => bloc.add(GamePlayEventInputWord('EXIST')),
      verify: (e) {
        expect(e.state.state, GamePlayActualState.wordFound);
        expect(e.state.revealedCells, [5, 6, 7, 8, 9]);
      },
    );

    blocTest<GamePlayBloc, GamePlayState>(
      'emits state wordFound with cell List, if word exists top to down',
      build: () => bloc,
      act: (bloc) => bloc.add(GamePlayEventInputWord('TEST')),
      verify: (e) {
        expect(e.state.state, GamePlayActualState.wordFound);
        expect(e.state.revealedCells, [9, 14, 19, 24]);
      },
    );

    blocTest<GamePlayBloc, GamePlayState>(
      'emits state alreadyFound if added twice',
      build: () => GamePlayBloc(levelData: levelData),
      act: (bloc) {
        bloc
          ..add(GamePlayEventInputWord('EXIST'))
          ..add(GamePlayEventInputWord('EXIST'));
      },
      skip: 1,
      //wait: Duration(milliseconds: 200),
      expect: () => [const GamePlayState(GamePlayActualState.alreadyFound)],
      //verify: (e) => expect(e.state.state, GamePlayActualState.alreadyFound),
    );
  });
}
