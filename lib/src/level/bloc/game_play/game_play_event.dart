part of 'game_play_bloc.dart';

@immutable
abstract class GamePlayEvent {}

class LoadLevelData extends GamePlayEvent {
  LoadLevelData();
}

class AddWord extends GamePlayEvent {
  AddWord({required this.word});

  final String word;
}

class ShuffleLetters extends GamePlayEvent {}

class FinishLevel extends GamePlayEvent {}
