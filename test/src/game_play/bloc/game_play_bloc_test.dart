import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sozzle/src/game_play/bloc/game_play_bloc.dart';
import 'package:sozzle/src/level/domain/level_data.dart';

void main() {
  group('GamePlayBloc Level1', () {
    late GamePlayBloc bloc;
/*

EXIST
    E
    S
    T
*/
    final levelData = LevelData(
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
      build: () => bloc,
      act: (bloc) {
        bloc
          ..add(GamePlayEventInputWord('EXIST'))
          ..add(GamePlayEventInputWord('EXIST'));
      },
      skip: 1,
      expect: () => [const GamePlayState(GamePlayActualState.alreadyFound)],
    );
  });

  group('GamePlayBloc Level2', () {
    late GamePlayBloc bloc;
/*
L W OWL
O O L O
WORLD W
R D   
*/
    final levelData = LevelData(
      boardData: [
        ...'L W OWL'.split(''),
        ...'O O L O'.split(''),
        ...'WORLD W'.split(''),
        ...'R D    '.split(''),
      ],
      boardWidth: 7,
      boardHeight: 4,
      levelId: 2,
      words: ['LOWR', 'WORD', 'OLD', 'LOW', 'OWL', 'WORLD'],
    );
    setUp(() {
      bloc = GamePlayBloc(levelData: levelData);
    });

    tearDown(() async {
      await bloc.close();
    });

    blocTest<GamePlayBloc, GamePlayState>(
      'emits state notFound if word does not exist',
      build: () => bloc,
      act: (bloc) => bloc.add(GamePlayEventInputWord('WOR')),
      expect: () => [const GamePlayState(GamePlayActualState.notFound)],
    );

    blocTest<GamePlayBloc, GamePlayState>(
      'emits state wordFound with cell List, if word exists left to right',
      build: () => bloc,
      act: (bloc) => bloc.add(GamePlayEventInputWord('WORLD')),
      verify: (e) {
        expect(e.state.state, GamePlayActualState.wordFound);
        expect(e.state.revealedCells, [14, 15, 16, 17, 18]);
      },
    );

    blocTest<GamePlayBloc, GamePlayState>(
      'emits state wordFound with cell List, if word exists top to down',
      build: () => bloc,
      act: (bloc) => bloc.add(GamePlayEventInputWord('LOW')),
      verify: (e) {
        expect(e.state.state, GamePlayActualState.wordFound);
        expect(e.state.revealedCells, [6, 13, 20]);
      },
    );

    blocTest<GamePlayBloc, GamePlayState>(
      'emits state alreadyFound if added twice',
      build: () => bloc,
      act: (bloc) {
        bloc
          ..add(GamePlayEventInputWord('WORD'))
          ..add(GamePlayEventInputWord('WORD'));
      },
      skip: 1,
      expect: () => [const GamePlayState(GamePlayActualState.alreadyFound)],
    );
  });
}
