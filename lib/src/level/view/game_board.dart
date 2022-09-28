import 'package:circular_pattern/circular_pattern.dart';
import 'package:flutter/material.dart';
import 'package:grid_board/grid_board.dart';
import 'package:sozzle/src/level/models/level.dart';
import 'package:sozzle/src/level/models/level_extension.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key, required this.levelData});
  static const String path = 'game';

  final LevelData levelData;

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  late GridBoardController? _controller;
  late GridSize _gridSize;
  late LevelData levelData;

  @override
  void initState() {
    super.initState();
    levelData = widget.levelData;
    _gridSize = GridSize(
      levelData.grid.rows,
      levelData.grid.cols,
    );
  }

  @override
  Widget build(BuildContext context) {
    _controller = GridBoardController(
      gridBoardProperties: GridBoardProperties(
        gridSize: _gridSize,
      ),
      cells: List.generate(_gridSize.cellCount, (index) {
        final val = levelData.getCellValue(index);
        return GridCell(
          gridCellChildMap: {
            GridCellStatus.initial: ConstrainedBox(
              constraints: const BoxConstraints.expand(),
              child: ColoredBox(
                color: Colors.blueAccent,
                child: Center(
                  child: val.isNotEmpty
                      ? Text(
                          val == '-' ? '' : val.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Container(
                          color: Colors.grey.shade300,
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
            SizedBox(
              height: _gridHeight,
              width: _gridHeight,
              child: _buildBoard(),
            ),
            SizedBox(
              height: _consoleHeight,
              child: Stack(
                children: [
                  CircularPattern(
                    onComplete: (List<PatternDot> input) {
                      final combination =
                          input.map((e) => e.value).join().toLowerCase();
                      if (levelData.includesWord(combination)) {
                        setState(() {
                          levelData.boardData
                              .firstWhere((word) => word.word == combination)
                              .reveal();
                        });
                      }
                    },
                    options: const CircularPatternOptions(
                      primaryTextStyle: TextStyle(fontSize: 4),
                      selectedTextStyle: TextStyle(fontSize: 4),
                    ),
                    dots: levelData.getUniqueLetters
                        .map(
                          (l) => PatternDot(value: l),
                        )
                        .toList(),
                  ),
                  Align(
                    child: IconButton(
                      onPressed: () =>
                          setState(() => levelData.words.shuffle()),
                      iconSize: 34,
                      color: const Color.fromARGB(255, 193, 215, 223),
                      splashRadius: 18,
                      icon: const DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(255, 193, 215, 223),
                        ),
                        child: Icon(
                          Icons.shuffle,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBoard() {
    return GridBoard(
      backgroundColor: Colors.white,
      controller: _controller!,
      gridSize: _gridSize,
    );
  }
}
