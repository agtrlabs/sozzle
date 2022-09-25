import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:grid_board/grid_board.dart';
import 'package:sozzle/services/mock_server.dart';
import 'package:sozzle/src/game/model/word_list.dart' as word;

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
                // final gridSize = GridSize(gridPosition.row, gridPosition.col);
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

                _controller = GridBoardController(
                  gridBoardProperties: GridBoardProperties(
                    gridSize: gridSize,
                  ),
                  cells: List.generate(gridSize.cellCount, (index) {
                    final letter = lettersGrid.firstWhereOrNull(
                      (e) =>
                          ((e.wordPosition.col * gridPosition.maxSize) +
                              e.wordPosition.row) ==
                          index,
                    );

                    debugPrint('letter: ${letter?.letter}');

                    // final x = words.firstWhereOrNull(
                    //   (element) =>
                    //       element.letters.firstWhereOrNull(
                    //         (e) =>
                    //             ((e.wordPosition.col * gridPosition.maxSize) +
                    //                 e.wordPosition.row) ==
                    //             index,
                    //       ) !=
                    //       null,
                    // );
                    // debugPrint('x: $x');

                    return GridCell(
                      gridCellChildMap: {
                        GridCellStatus.initial: ConstrainedBox(
                          constraints: const BoxConstraints.expand(),
                          child: ColoredBox(
                            color: Colors.green,
                            child: Center(
                              child: letter != null
                                  ? Text(
                                      letter.letter,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : Container(
                                      color: Colors.green,
                                    ),
                            ),
                          ),
                        ),
                      },
                    );
                  }),
                );

                return LayoutBuilder(
                  builder: (context, constraints) {
                    double _gridHeight;
                    double _consoleHeight;
                    if (constraints.maxWidth < constraints.maxHeight * 0.6) {
                      _gridHeight = constraints.maxWidth;
                      _consoleHeight = constraints.maxHeight - _gridHeight;
                    } else {
                      _gridHeight = constraints.maxHeight * 0.6;
                      _consoleHeight = constraints.maxHeight - _gridHeight;
                    }

                    return Column(
                      children: [
                        Center(
                          child: SizedBox(
                            height: _gridHeight,
                            child: GridBoard(
                              backgroundColor: Colors.white,
                              controller: _controller!,
                              onTap: (value) {
                                debugPrint(
                                  'clicked cell --- row: ${value.gridPosition.rowIndex}, col: ${value.gridPosition.columnIndex}',
                                );
                              },
                              gridSize: gridSize,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: _consoleHeight,
                          child: Container(color: Colors.blue),
                        ),
                      ],
                    );
                  },
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
