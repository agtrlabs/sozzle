import 'package:flutter/material.dart';
import 'package:grid_board/grid_board.dart';
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
  // final _gridSize = const GridSize(
  //   10,
  //   10,
  // );
  GridBoardController? _controller;
  late final Future<Map<String, dynamic>> _mockData;

  @override
  void initState() {
    super.initState();
    _mockData = MockServer().loadAsset();
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
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
                final gridPosition = word.GridPosition.fromMap(data);
                final gridSize = GridSize(
                  gridPosition.maxSize,
                  gridPosition.maxSize,
                );
                final words = (data['data'] as List)
                    .map(
                      (w) => word.Word.fromMap(w as Map<String, dynamic>),
                    )
                    .toList();

                final lettersGrid = words
                    .expand(
                      (word) => word.letters,
                    )
                    .toList();
                return GameBoard(
                  gridSize: gridSize,
                  lettersGrid: lettersGrid,
                  gridPosition: gridPosition,
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
