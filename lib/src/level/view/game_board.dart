import 'package:circular_pattern/circular_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grid_board/grid_board.dart';
import 'package:sozzle/src/level/bloc/game_play/game_play_bloc.dart';
import 'package:sozzle/src/level/models/level.dart';
import 'package:sozzle/src/level/models/level_extension.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({super.key, required this.levelData});
  static const String path = 'game';

  final LevelData levelData;

  @override
  Widget build(BuildContext context) {
    final _gridSize = GridSize(
      levelData.grid.rows,
      levelData.grid.cols,
    );

    final _controller = GridBoardController(
      gridBoardProperties: GridBoardProperties(
        gridSize: _gridSize,
      ),
      cells: List.generate(_gridSize.cellCount, (index) {
        final val = levelData.getCellValue(index);
        return GridCell(
          gridCellChildMap: {
            GridCellStatus.initial: ConstrainedBox(
              constraints: const BoxConstraints.expand(),
              child: val != ReveilSelection.blocked.name
                  ? DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        border: Border.all(),
                      ),
                      child: Center(
                        child: Text(
                          (val == ReveilSelection.concealed.name ||
                                  val == ReveilSelection.blocked.name)
                              ? ''
                              : val.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : Container(),
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
            _buildBoard(
              gridHeight: _gridHeight,
              gridWidth: _gridHeight,
              controller: _controller,
              gridSize: _gridSize,
            ),
            _buildControlPanel(context, _consoleHeight),
          ],
        );
      },
    );
  }

  Widget _buildBoard({
    required double gridHeight,
    required double gridWidth,
    required GridBoardController controller,
    required GridSize gridSize,
  }) {
    return SizedBox(
      height: gridHeight,
      width: gridWidth,
      child: GridBoard(
        backgroundColor: Colors.white,
        controller: controller,
        gridSize: gridSize,
      ),
    );
  }

  Widget _buildControlPanel(BuildContext context, double consoleHeight) {
    return SizedBox(
      height: consoleHeight,
      child: Stack(
        children: [
          CircularPattern(
            onComplete: (List<PatternDot> input) {
              final combination =
                  input.map((e) => e.value).join().toLowerCase();
              BlocProvider.of<GamePlayBloc>(context)
                  .add(AddWord(word: combination));
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
              onPressed: () {
                BlocProvider.of<GamePlayBloc>(context).add(ShuffleLetters());
              },
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
