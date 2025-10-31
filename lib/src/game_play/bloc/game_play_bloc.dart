import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:level_data/level_data.dart';
import 'package:sozzle/src/audio/domain/i_audio_controller.dart';
import 'package:sozzle/src/audio/domain/sfx.dart';
import 'package:uuid/uuid.dart';

part 'game_play_event.dart';
part 'game_play_state.dart';

class GamePlayBloc extends HydratedBloc<GamePlayEvent, GamePlayState> {
  GamePlayBloc({
    required this.levelData,
    required this.audio,
  }) : super(GamePlayState(GamePlayActualState.allHidden)) {
    on<GamePlayEventInputWord>(_handleInputWord);
    on<RevealRandomLetterEvent>(_handleRevealRandomLetter);
    on<GamePlayInitialEvent>((event, emit) {
      emit(GamePlayState(GamePlayActualState.initial));
    });
  }

  final LevelData levelData;
  final IAudioController audio;

  List<String> foundWords = [];
  List<int> revealedCells = [];

  int _getIndex(int col, int row, int height) {
    return col * height + row;
  }

  /// scans board data left to right
  /// if word is found return indexes of letters
  List<int> _scanLR(String word) {
    final result = <int>[];
    for (var row = 0; row < levelData.boardHeight; row++) {
      var wordPointer = 0;
      result.clear();
      for (var col = 0; col < levelData.boardWidth; col++) {
        //check current cell matches with wordPointer
        final currentIndex = _getIndex(col, row, levelData.boardHeight);
        if (levelData.boardData[currentIndex] == word[wordPointer]) {
          result.add(currentIndex);
          wordPointer++;
          if (wordPointer == word.length) {
            // check if next letter is empty or pointer is at the end
            if (col == levelData.boardWidth - 1) {
              return result;
            } else {
              final nextIndex = _getIndex(col + 1, row, levelData.boardHeight);
              if ((levelData.boardData[nextIndex] == '') ||
                  (levelData.boardData[nextIndex] == ' ')) {
                return result;
              } else {
                wordPointer = 0;
                result.clear();
              }
            }
          }
        } else {
          wordPointer = 0;
          result.clear();
        }
        if (wordPointer >= word.length) {
          col = levelData.boardWidth;
        }
      }
    }
    return result;
  }

  /// scans each column top to down to find the word
  List<int> _scanTD(String word) {
    final result = <int>[];
    for (var col = 0; col < levelData.boardWidth; col++) {
      var wordPointer = 0;
      result.clear();
      for (var row = 0; row < levelData.boardHeight; row++) {
        //check current cell matches with wordPointer
        final currentIndex = _getIndex(col, row, levelData.boardHeight);

        if (levelData.boardData[currentIndex] == word[wordPointer]) {
          result.add(currentIndex);
          wordPointer++;
          if (wordPointer == word.length) {
            // check if next letter is empty or pointer is at the end
            if (row == levelData.boardHeight - 1) {
              return result;
            } else {
              final nextIndex = _getIndex(col, row + 1, levelData.boardHeight);
              if ((levelData.boardData[nextIndex] == '') ||
                  (levelData.boardData[nextIndex] == ' ')) {
                return result;
              } else {
                wordPointer = 0;
                result.clear();
              }
            }
          }
        } else {
          wordPointer = 0;
          result.clear();
        }
        if (wordPointer >= word.length) {
          col = levelData.boardWidth;
        }
      }
    }
    return result;
  }

  List<int> _scan(String word) {
    final list = _scanLR(word);
    return list.length == word.length ? list : _scanTD(word);
  }

  FutureOr<void> _handleInputWord(
    GamePlayEventInputWord event,
    Emitter<GamePlayState> emit,
  ) {
    // TODO(me): implement bonusWord
    if (!levelData.words.contains(event.word)) {
      audio.play(Sfx.error);
      emit(GamePlayState(GamePlayActualState.notFound));
    } else {
      // scan the board
      final indexList = _scan(event.word);
      // if word found
      if (indexList.length == event.word.length) {
        //check if alreadyFound
        if (foundWords.contains(event.word)) {
          audio.play(Sfx.hint);
          emit(GamePlayState(GamePlayActualState.alreadyFound));
        } else {
          // else add to foundWords
          foundWords.add(event.word);
          revealedCells.addAll(indexList);
          emit(
            GamePlayState(GamePlayActualState.wordFound),
          );

          //check if all words found
          if (foundWords.length == levelData.words.length) {
            audio.play(Sfx.win);
            emit(
              GamePlayState(GamePlayActualState.allFound),
            );
          } else {
            audio.play(Sfx.open);
          }
        }
      }
    }
  }

  // coverage:ignore-start
  FutureOr<void> _handleRevealRandomLetter(
    RevealRandomLetterEvent event,
    Emitter<GamePlayState> emit,
  ) {
    final random = Random();
    final availableIndices =
        List<int>.generate(levelData.boardData.length, (i) => i)
          ..removeWhere(
            (index) =>
                levelData.boardData[index].trim() == '' ||
                revealedCells.contains(index),
          );

    if (availableIndices.isNotEmpty) {
      final index = availableIndices[random.nextInt(availableIndices.length)];
      revealedCells.add(index);
      emit(LetterRevealed(index));
    }
  }

  @override
  GamePlayState? fromJson(Map<String, dynamic> json) {
    if (json[levelData.levelId.toString()] != null) {
      final data = json[levelData.levelId.toString()] as Map<String, dynamic>;
      foundWords = List<String>.from(data['foundWords'] as List);
      final revealedCells = List<int>.from(data['revealedCells'] as List);
      this.revealedCells = revealedCells;
    }
    return state;
  }
  // coverage:ignore-end

  @override
  Map<String, dynamic>? toJson(GamePlayState state) {
    return {
      levelData.levelId.toString(): {
        'foundWords': foundWords,
        'revealedCells': revealedCells,
      },
    };
  }
}
