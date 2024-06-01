part of 'game_play_bloc.dart';

class GamePlayState extends Equatable {
  const GamePlayState(this.state);

  final GamePlayActualState state;

  @override
  List<Object> get props => [state];
}

enum GamePlayActualState {
  initial,
  allHidden,
  wordFound,
  alreadyFound,
  bonusWord,
  notFound,
  allFound,
}
