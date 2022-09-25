import 'package:flutter/material.dart';
import 'package:grid_board/grid_board.dart';

class Game extends StatefulWidget {
  const Game({super.key});
  static const String path = 'game';

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  final _gridSize = const GridSize(
    10,
    10,
  );
  late final GridBoardController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GridBoardController(
      gridBoardProperties: GridBoardProperties(
        gridSize: _gridSize,
      ),
      cells: List.generate(
        100,
        (index) => GridCell(
          gridCellChildMap: {
            GridCellStatus.initial: ConstrainedBox(
              constraints: const BoxConstraints.expand(),
              child: ColoredBox(
                color: Colors.green,
                child: Center(
                  child: Text(
                    index.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
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

            debugPrint('cell at 2: ${_controller.moveToList}');
            return Column(
              children: [
                SizedBox(
                  height: _gridHeight,
                  child: GridBoard(
                    backgroundColor: Colors.white,
                    controller: _controller,
                    onTap: (value) {
                      _controller.cleanRotation(2);
                      debugPrint(
                        'clicked cell --- row: ${value.gridPosition.rowIndex}, col: ${value.gridPosition.columnIndex}',
                      );
                    },
                    gridSize: _gridSize,
                  ),
                ),
                SizedBox(
                  height: _consoleHeight,
                  child: Container(color: Colors.blue),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
