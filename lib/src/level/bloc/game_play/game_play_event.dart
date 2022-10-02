part of 'game_play_bloc.dart';

@immutable
abstract class GamePlayEvent {}

class LoadLevelData extends GamePlayEvent {
  LoadLevelData({required this.level});

  final int level;
}

class AddWord extends GamePlayEvent {
  AddWord({required this.word});

  final String word;
}

class ShuffleLetters extends GamePlayEvent {}

class FinishLevel extends GamePlayEvent {
  FinishLevel(this.level);

  final int level;
}
