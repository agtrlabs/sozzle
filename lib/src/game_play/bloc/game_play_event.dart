// coverage:ignore-file
part of 'game_play_bloc.dart';

sealed class GamePlayEvent extends Equatable {
  const GamePlayEvent();

  @override
  List<Object> get props => [];
}

final class GamePlayEventInputWord extends GamePlayEvent {
  const GamePlayEventInputWord(this.word);

  final String word;

  @override
  List<Object> get props => [word];
}

final class GamePlayInitialEvent extends GamePlayEvent {
  const GamePlayInitialEvent();
}
