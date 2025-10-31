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
    letters = [];

    for (final char in widget.levelData.boardData) {
      if (char.trim().isNotEmpty) letters.add(char);
    }

    normaliseLetterList();

    letters.shuffle();

    super.initState();
  }

  // coverage:ignore-start
  void normaliseLetterList() {
    final letterCount = <String, int>{};
    for (final word in widget.levelData.words) {
      // Holds the count of each letter in the current word
      final wordLetterCount = <String, int>{};
      // For each letter in the word, count its occurrences
      // and store in wordLetterCount
      for (final char in word.split('')) {
        wordLetterCount[char] = (wordLetterCount[char] ?? 0) + 1;
      }
      // Update the overall letterCount to ensure it has
      // the maximum count needed for each letter
      // For example, if the letter 'A' appears 2 times in one word
      // and 3 times in another, letterCount['A'] should be 3
      for (final entry in wordLetterCount.entries) {
        final char = entry.key;
        final count = entry.value;
        if (letterCount.containsKey(char)) {
          letterCount[char] =
              letterCount[char]! < count ? count : letterCount[char]!;
        } else {
          letterCount[char] = count;
        }
      }
    }

    /// I need this check to avoid clearing letters when we're in a test
    /// environment where levelData.words might be empty.
    if (widget.levelData.words.isNotEmpty) {
      letters.clear();

      letterCount.forEach((char, count) {
        for (var i = 0; i < count; i++) {
          letters.add(char);
        }
      });
    }
  }

  // coverage:ignore-end
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

  // coverage:ignore-start
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
      context.read<GamePlayBloc>().add(GamePlayEventInputWord(word));
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
  // coverage:ignore-end
}
