import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sozzle/services/mock_server.dart';

import 'package:sozzle/src/level/models/level.dart';
import 'package:sozzle/src/level/models/level_extension.dart';

part 'game_play_event.dart';
part 'game_play_state.dart';

class GamePlayBloc extends Bloc<GamePlayEvent, GamePlayState> {
  GamePlayBloc() : super(GamePlayInitial()) {
    on<LoadLevelData>(_onLoadLevelData);
    on<AddWord>(_onAddWord);
    on<ShuffleLetters>(_onShuffleLetters);
  }

  Future<void> _onLoadLevelData(
    LoadLevelData event,
    Emitter<GamePlayState> emit,
  ) async {
    final data = await MockServer().loadAsset();
    emit(GamePlayLoaded(levelData: LevelData.fromMap(data)));
  }

  void _onAddWord(AddWord event, Emitter<GamePlayState> emit) {
    final state = this.state;
    if (state is GamePlayLoaded) {
      final wordExists = state.levelData.includesWord(event.word);
      if (wordExists) {
        state.levelData.wordIsFound(event.word);
        state.levelData.boardData
            .firstWhere((word) => word.word == event.word)
            .reveal();
      }
      emit(
        GamePlayLoaded(levelData: state.levelData),
      );
    }
  }

  void _onShuffleLetters(ShuffleLetters event, Emitter<GamePlayState> emit) {
    final state = this.state;
    if (state is GamePlayLoaded) {
      state.levelData.shuffle();
      emit(
        GamePlayLoaded(levelData: state.levelData),
      );
    }
  }
}
