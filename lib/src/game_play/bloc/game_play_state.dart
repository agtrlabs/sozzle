part of 'game_play_bloc.dart';

class GamePlayState extends Equatable {
  const GamePlayState(this.actualState);

  final GamePlayActualState actualState;

  @override
  List<Object> get props => [actualState];
}

enum GamePlayActualState {
  initial,
  allHidden,
  wordFound,
  alreadyFound,
  bonusWord,
  notFound,
  allFound,
  letterRevealed,
}

class LetterRevealed extends GamePlayState {
  const LetterRevealed(this.revealedIndex)
      : super(GamePlayActualState.letterRevealed);

  final int revealedIndex;

  @override
  List<Object> get props => [revealedIndex];
}
