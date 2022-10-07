import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sozzle/src/level/domain/level_data.dart';

part 'game_play_event.dart';
part 'game_play_state.dart';

class GamePlayBloc extends Bloc<GamePlayEvent, GamePlayState> {
  GamePlayBloc({required this.levelData})
      : super(const GamePlayState(GamePlayActualState.allHidden)) {
    on<GamePlayEventInputWord>((event, emit) {
      if (!levelData.words.contains(event.word)) {
        emit(const GamePlayState(GamePlayActualState.notFound));
      } else {
        // scan the board
        final indexList = _scan(event.word);
        // if word found
        if (indexList.length == event.word.length) {
          //check if alreadyFound
          if (foundWords.contains(event.word)) {
            emit(const GamePlayState(GamePlayActualState.alreadyFound));
          } else {
            // else add to foundWords
            foundWords.add(event.word);
            emit(
              GamePlayState(GamePlayActualState.wordFound, indexList),
            );
          }
        }
      }
    });
  }
  final LevelData levelData;

  List<String> foundWords = [];

  /// scans board data letf to right
  /// if word is found return indexes of letters
  List<int> _scanLR(String word) {
    var result = <int>[];
    for (var row = 0; row < levelData.boardHeight; row++) {
      var wordPointer = 0;
      result = [];
      for (var col = 0; col < levelData.boardWidth; col++) {
        //check current cell matches with wordPointer
        final currentIndex = row * levelData.boardWidth + col;
        if (levelData.boardData[currentIndex] == word[wordPointer]) {
          result.add(currentIndex);

          if (wordPointer == word.length - 1) return result;
          wordPointer++;
        } else {
          wordPointer = 0;
          result = [];
        }
      }
    }
    return result;
  }

  // scan each column top to down to find the word
  List<int> _scanTD(String word) {
    var result = <int>[];
    for (var col = 0; col < levelData.boardWidth; col++) {
      var wordPointer = 0;
      result = [];
      for (var row = 0; row < levelData.boardHeight; row++) {
        //check current cell matches with wordPointer
        final currentIndex = row * levelData.boardWidth + col;
        if (levelData.boardData[currentIndex] == word[wordPointer]) {
          result.add(currentIndex);
          if (wordPointer == word.length - 1) return result;
          wordPointer++;
        } else {
          result = [];
        }
      }
    }
    return result;
  }

  List<int> _scan(String word) {
    final list = _scanLR(word);
    return list.length == word.length ? list : _scanTD(word);
  }
}
