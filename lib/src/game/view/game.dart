import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sozzle/services/mock_server.dart';
import 'package:sozzle/src/game/model/word_list.dart' as word;
import 'package:sozzle/src/game/view/game_board.dart';

class Game extends StatefulWidget {
  const Game({super.key});
  static const String path = 'game';

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  late final Future<Map<String, dynamic>> _mockData;

  @override
  void initState() {
    super.initState();
    _mockData = MockServer().loadAsset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _mockData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData && snapshot.data != null) {
                final data = snapshot.data!;
                final wordList = word.WordList.fromMap(
                  data,
                );

                return GameBoard(
                  wordList: wordList,
                );
              }

              if (snapshot.hasError) {
                return const Center(
                  child: Text('Something went wrong!'),
                );
              }

              return const Center(
                child: Text('No data available.'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
