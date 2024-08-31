part of 'game_play_bloc.dart';

class GamePlayState extends Equatable {
  GamePlayState(this.actualState) : uniqueIdentifier = const Uuid().v4();

  final GamePlayActualState actualState;
  // When the state goes from wordFound - wordFound, the state is not
  // changed, this is because the equality is checked by the actualState, in
  // order to solve this, we can add a unique identifier to the state,
  // for example, the word that was found, or the letter that was revealed.
  // or better yet generate a unique identifier for each state.
  final String uniqueIdentifier;

  @override
  List<Object> get props => [actualState, uniqueIdentifier];
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
  LetterRevealed(this.revealedIndex)
      : super(GamePlayActualState.letterRevealed);

  final int revealedIndex;

  @override
  List<Object> get props => [revealedIndex];
}
