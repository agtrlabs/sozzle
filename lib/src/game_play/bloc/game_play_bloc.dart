import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sozzle/src/level/domain/level_data.dart';

part 'game_play_event.dart';
part 'game_play_state.dart';

class GamePlayBloc extends Bloc<GamePlayEvent, GamePlayState> {
  GamePlayBloc({required this.levelData})
      : super(const GamePlayState(GamePlayActualState.allHidden)) {
    on<GamePlayEvent>((event, emit) {
      // TODO(any): implement event handler
    });
  }
  final LevelData levelData;
}