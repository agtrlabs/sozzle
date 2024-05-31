// coverage:ignore-file
part of 'game_play_bloc.dart';

abstract class GamePlayEvent extends Equatable {
  const GamePlayEvent();

  @override
  List<Object> get props => [];
}

class GamePlayEventInputWord implements GamePlayEvent {
  GamePlayEventInputWord(this.word);

  final String word;

  @override
  List<Object> get props => [word];

  @override
  bool? get stringify => false;
}
