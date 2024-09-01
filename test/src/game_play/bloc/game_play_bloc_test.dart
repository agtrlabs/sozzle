import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:level_data/level_data.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sozzle/src/audio/domain/i_audio_controller.dart';
import 'package:sozzle/src/audio/domain/sfx.dart';
import 'package:sozzle/src/game_play/bloc/game_play_bloc.dart';

class MockAudio extends Mock implements IAudioController {}

class MockStorage extends Mock implements Storage {}

void main() {
  late MockAudio audio;
  late Storage storage;

  setUpAll(() {
    registerFallbackValue(Sfx.open);
    audio = MockAudio();
    when(() => audio.play(any())).thenReturn(null);
    storage = MockStorage();
    when(
      () => storage.write(any(), any<dynamic>()),
    ).thenAnswer((_) async {});
    HydratedBloc.storage = storage;
  });

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
      words: const ['EXIST', 'TEST'],
    );
    setUp(() {
      bloc = GamePlayBloc(
        levelData: levelData,
        audio: audio,
      );
    });

    tearDown(() async {
      await bloc.close();
    });

    test('Initial State test', () {
      expect(bloc.state, GamePlayState(GamePlayActualState.allHidden));
    });

    blocTest<GamePlayBloc, GamePlayState>(
      'emits state notFound if word does not exist',
      build: () => bloc,
      act: (bloc) => bloc.add(const GamePlayEventInputWord('NOTEXIST')),
      expect: () => [GamePlayState(GamePlayActualState.notFound)],
      //verify: (e) => expect(e.state.state, GamePlayActualState.notFound),
    );

    blocTest<GamePlayBloc, GamePlayState>(
      'emits state wordFound with cell List, if word exists left to right',
      build: () => bloc,
      act: (bloc) => bloc.add(const GamePlayEventInputWord('EXIST')),
      verify: (e) {
        expect(e.state.actualState, GamePlayActualState.wordFound);
        expect(e.revealedCells, [5, 6, 7, 8, 9]);
      },
    );

    blocTest<GamePlayBloc, GamePlayState>(
      'emits state wordFound with cell List, if word exists top to down',
      build: () => bloc,
      act: (bloc) => bloc.add(const GamePlayEventInputWord('TEST')),
      verify: (e) {
        expect(e.state.actualState, GamePlayActualState.wordFound);
        expect(e.revealedCells, [9, 14, 19, 24]);
      },
    );

    blocTest<GamePlayBloc, GamePlayState>(
      'emits state alreadyFound if added twice',
      build: () => bloc,
      act: (bloc) {
        bloc
          ..add(const GamePlayEventInputWord('EXIST'))
          ..add(const GamePlayEventInputWord('EXIST'));
      },
      skip: 1,
      expect: () => [GamePlayState(GamePlayActualState.alreadyFound)],
    );

    blocTest<GamePlayBloc, GamePlayState>(
      'emits state allFound after last wordFound',
      build: () => bloc,
      act: (bloc) {
        for (final word in levelData.words) {
          bloc.add(GamePlayEventInputWord(word));
        }
      },
      skip: 1,
      expect: () => [
        for (int i = 0; i < levelData.words.length - 1; i++)
          isA<GamePlayState>().having(
            (e) => e.actualState,
            'actualState',
            GamePlayActualState.wordFound,
          ),
        GamePlayState(GamePlayActualState.allFound),
      ],
    );

    blocTest<GamePlayBloc, GamePlayState>(
      'should play sound on word found',
      build: () => bloc,
      act: (bloc) => bloc.add(const GamePlayEventInputWord('TEST')),
      verify: (bloc) {
        verify(() => audio.play(any())).called(greaterThan(0));
      },
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
        ...'LOWR'.split(''),
        ...'  O '.split(''),
        ...'WORD'.split(''),
        ...'  L '.split(''),
        ...'OLD '.split(''),
        ...'W   '.split(''),
        ...'LOW '.split(''),
      ],
      boardWidth: 7,
      boardHeight: 4,
      levelId: 2,
      words: const ['LOWR', 'WORD', 'OLD', 'LOW', 'OWL', 'WORLD'],
    );
    setUp(() {
      bloc = GamePlayBloc(
        levelData: levelData,
        audio: audio,
      );
    });

    tearDown(() async {
      await bloc.close();
    });

    blocTest<GamePlayBloc, GamePlayState>(
      'emits state notFound if word does not exist',
      build: () => bloc,
      act: (bloc) => bloc.add(const GamePlayEventInputWord('WOR')),
      expect: () => [GamePlayState(GamePlayActualState.notFound)],
    );

    blocTest<GamePlayBloc, GamePlayState>(
      'emits state wordFound with cell List, if word exists left to right',
      build: () => bloc,
      act: (bloc) => bloc.add(const GamePlayEventInputWord('WORLD')),
      verify: (e) {
        expect(e.state.actualState, GamePlayActualState.wordFound);
        expect(e.revealedCells, [2, 6, 10, 14, 18]);
      },
    );

    blocTest<GamePlayBloc, GamePlayState>(
      'emits state wordFound with cell List, if word exists top to down',
      build: () => bloc,
      act: (bloc) => bloc.add(const GamePlayEventInputWord('LOW')),
      verify: (e) {
        expect(e.state.actualState, GamePlayActualState.wordFound);
        expect(e.revealedCells, [24, 25, 26]);
      },
    );

    blocTest<GamePlayBloc, GamePlayState>(
      'emits state alreadyFound if added twice',
      build: () => bloc,
      act: (bloc) {
        bloc
          ..add(const GamePlayEventInputWord('WORD'))
          ..add(const GamePlayEventInputWord('WORD'));
      },
      skip: 1,
      expect: () => [GamePlayState(GamePlayActualState.alreadyFound)],
    );

    blocTest<GamePlayBloc, GamePlayState>(
      'emits state allFound after last wordFound',
      build: () => bloc,
      act: (bloc) {
        for (final word in levelData.words) {
          bloc.add(GamePlayEventInputWord(word));
        }
      },
      skip: 1,
      expect: () => [
        for (int i = 0; i < levelData.words.length - 1; i++)
          isA<GamePlayState>().having(
            (e) => e.actualState,
            'actualState',
            GamePlayActualState.wordFound,
          ),
        GamePlayState(GamePlayActualState.allFound),
      ],
    );
  });
}
