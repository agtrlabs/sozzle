import 'dart:async';

import 'package:circular_pattern/circular_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:level_data/level_data.dart';
import 'package:sozzle/src/audio/domain/i_audio_controller.dart';
import 'package:sozzle/src/audio/domain/sfx.dart';
import 'package:sozzle/src/game_play/game_play.dart';
import 'package:sozzle/src/game_play/view/components/guess_text.dart';

class GamePlayLetters extends StatefulWidget {
  const GamePlayLetters(this.levelData, {super.key});
  final LevelData levelData;
  @override
  State<GamePlayLetters> createState() => _GamePlayLettersState();
}

class _GamePlayLettersState extends State<GamePlayLetters> {
  late final List<String> letters;
  String guess = '';
  Timer clearGuessTimer = Timer(Duration.zero, () {});

  @override
  void initState() {
    // TODO(check): if needed, find anotherway to extract letters
    letters = widget.levelData.boardData.toSet().toList()
      ..remove(' ')
      ..remove('');
    super.initState();
  }

  @override
  void dispose() {
    clearGuessTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      //direction: Axis.vertical,
      children: [
        GuessText(guess),
        Expanded(
          child: CircularPattern(
            //pointRadius: 15,
            dots: letters.map((e) => PatternDot(value: e)).toList(),
            onStart: _onInputStart,
            onChange: _onInputChange,
            onComplete: _onInputComplete,
            minInputLength: 1,
          ),
        ),
      ],
    );
  }

  void _onInputStart() {
    _clearGuess();
    clearGuessTimer.cancel();
  }

  void _onInputChange(List<PatternDot> input) {
    RepositoryProvider.of<IAudioController>(context).play(Sfx.slide);
    setState(() {
      guess = input.map((e) => e.value).toList().join();
    });
  }

  void _onInputComplete(List<PatternDot> input) {
    clearGuessTimer = getTimerToCleanInput(500);
    if (input.length >= 3) {
      final word = input.map((e) => e.value).toList().join();
      BlocProvider.of<GamePlayBloc>(context).add(GamePlayEventInputWord(word));
    }
  }

  Timer getTimerToCleanInput(int ms) => Timer(
        Duration(milliseconds: ms),
        _clearGuess,
      );

  void _clearGuess() {
    setState(() {
      guess = '';
    });
  }
}
