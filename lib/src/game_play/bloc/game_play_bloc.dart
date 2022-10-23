import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:level_data/level_data.dart';
import 'package:sozzle/src/audio/domain/i_audio_controller.dart';
import 'package:sozzle/src/audio/domain/sfx.dart';

part 'game_play_event.dart';
part 'game_play_state.dart';

class GamePlayBloc extends Bloc<GamePlayEvent, GamePlayState> {
  GamePlayBloc({
    required this.levelData,
    required this.audio,
  }) : super(const GamePlayState(GamePlayActualState.allHidden)) {
    on<GamePlayEventInputWord>(handleInputWord);
  }
  final LevelData levelData;
  final IAudioController audio;

  List<String> foundWords = [];

  /// scans board data letf to right
  /// if word is found return indexes of letters
  List<int> _scanLR(String word) {
    final result = <int>[];
    for (var row = 0; row < levelData.boardHeight; row++) {
      var wordPointer = 0;
      result.clear();
      for (var col = 0; col < levelData.boardWidth; col++) {
        //check current cell matches with wordPointer
        final currentIndex = row * levelData.boardWidth + col;
        if (levelData.boardData[currentIndex] == word[wordPointer]) {
          result.add(currentIndex);
          wordPointer++;
          if (wordPointer == word.length) {
            // check if next letter is empty or pointer is at the end
            if (col == levelData.boardWidth - 1) {
              return result;
            } else {
              final nextIndex = row * levelData.boardWidth + col + 1;
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

  // scan each column top to down to find the word
  List<int> _scanTD(String word) {
    final result = <int>[];
    for (var col = 0; col < levelData.boardWidth; col++) {
      var wordPointer = 0;
      result.clear();
      for (var row = 0; row < levelData.boardHeight; row++) {
        //check current cell matches with wordPointer
        final currentIndex = row * levelData.boardWidth + col;

        if (levelData.boardData[currentIndex] == word[wordPointer]) {
          result.add(currentIndex);
          wordPointer++;
          if (wordPointer == word.length) {
            // check if next letter is empty or pointer is at the end
            if (row == levelData.boardHeight - 1) {
              return result;
            } else {
              final nextIndex = (row + 1) * levelData.boardWidth + col;
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

  FutureOr<void> handleInputWord(
    GamePlayEventInputWord event,
    Emitter<GamePlayState> emit,
  ) {
    // TODO(me): implement bonusWord
    if (!levelData.words.contains(event.word)) {
      audio.play(Sfx.error);
      emit(const GamePlayState(GamePlayActualState.notFound));
    } else {
      // scan the board
      final indexList = _scan(event.word);
      // if word found
      if (indexList.length == event.word.length) {
        //check if alreadyFound
        if (foundWords.contains(event.word)) {
          audio.play(Sfx.hint);
          emit(const GamePlayState(GamePlayActualState.alreadyFound));
        } else {
          // else add to foundWords
          foundWords.add(event.word);
          emit(
            GamePlayState(GamePlayActualState.wordFound, indexList),
          );
          //check if all words found
          if (foundWords.length == levelData.words.length) {
            audio.play(Sfx.win);
            emit(
              const GamePlayState(GamePlayActualState.allFound),
            );
          } else {
            audio.play(Sfx.open);
          }
        }
      }
    }
  }
}
