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
                  child: val != ReveilSelection.blocked.name
                      ? Text(
                          val == ReveilSelection.concealed.name
                              ? ''
                              : val.toUpperCase(),
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
            _buildBoard(_gridHeight, _gridHeight),
            _buildControlPanel(_consoleHeight),
          ],
        );
      },
    );
  }

  Widget _buildBoard(double gridHeight, double gridWidth) {
    return SizedBox(
      height: gridHeight,
      width: gridWidth,
      child: GridBoard(
        backgroundColor: Colors.white,
        controller: _controller!,
        gridSize: _gridSize,
      ),
    );
  }

  Widget _buildControlPanel(double consoleHeight) {
    return SizedBox(
      height: consoleHeight,
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
              primaryTextStyle: TextStyle(fontSize: 14),
              selectedTextStyle: TextStyle(
                fontSize: 14,
              ),
            ),
            dots: levelData.getUniqueLetters
                .map(
                  (l) => PatternDot(value: l),
                )
                .toList(),
          ),
          Align(
            child: ElevatedButton(
              onPressed: () => setState(
                () => levelData.shuffle(),
              ),
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(10),
                backgroundColor: const Color.fromARGB(255, 193, 215, 223),
              ),
              child: const Icon(
                Icons.shuffle,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
