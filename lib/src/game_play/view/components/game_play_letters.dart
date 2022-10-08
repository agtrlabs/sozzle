import 'package:circular_pattern/circular_pattern.dart';
import 'package:flutter/material.dart';
import 'package:sozzle/src/level/domain/level_data.dart';

class GamePlayLetters extends StatelessWidget {
  const GamePlayLetters(this.levelData, {super.key});
  final LevelData levelData;

  @override
  Widget build(BuildContext context) {
    // TODO(check): if needed, find anotherway to extract letters
    final letters = levelData.boardData.toSet().toList()
      ..remove(' ')
      ..remove('');

    return Padding(
      padding: const EdgeInsets.all(18),
      child: AspectRatio(
        aspectRatio: 1,
        child: CircularPattern(
          dots: letters.map((e) => PatternDot(value: e)).toList(),
          onComplete: (input) {},
        ),
      ),
    );
  }
}
