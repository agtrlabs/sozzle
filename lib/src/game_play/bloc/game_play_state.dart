part of 'game_play_bloc.dart';

class GamePlayState extends Equatable {
  const GamePlayState(this.state, [this.revealedCells = const []]);

  final List<int> revealedCells;
  final GamePlayActualState state;
  @override
  List<Object> get props => [revealedCells, state];
}

enum GamePlayActualState {
  allHidden,
  wordFound,
  alreadyFound,
  bonusWord,
  notFound,
  allFound,
}
