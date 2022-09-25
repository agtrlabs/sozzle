import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:grid_board/grid_board.dart';
import 'package:sozzle/src/game/model/word_list.dart' as word;

class GameBoard extends StatefulWidget {
  const GameBoard({
    super.key,
    required this.gridSize,
    required this.lettersGrid,
    required this.gridPosition,
  });

  final GridSize gridSize;
  final List<word.LetterGrid> lettersGrid;
  final word.GridPosition gridPosition;

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  late List<word.LetterGrid> lettersGrid;
  @override
  void initState() {
    super.initState();
    lettersGrid = widget.lettersGrid;
  }

  @override
  Widget build(BuildContext context) {
    final _controller = GridBoardController(
      gridBoardProperties: GridBoardProperties(
        gridSize: widget.gridSize,
      ),
      cells: List.generate(widget.gridSize.cellCount, (index) {
        final letter = lettersGrid.firstWhereOrNull(
          (e) =>
              ((e.wordPosition.col * widget.gridPosition.maxSize) +
                  e.wordPosition.row) ==
              index,
        );

        debugPrint('letter: ${letter?.letter}');

        return GridCell(
          gridCellChildMap: {
            GridCellStatus.initial: ConstrainedBox(
              constraints: const BoxConstraints.expand(),
              child: ColoredBox(
                color: Colors.blueAccent,
                child: Center(
                  child: letter != null
                      ? Text(
                          letter.isClicked ? letter.letter : '',
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
            Center(
              child: SizedBox(
                height: _gridHeight,
                child: GridBoard(
                  backgroundColor: Colors.white,
                  controller: _controller,
                  onTap: (value) {
                    final clickedLetter = lettersGrid
                        .firstWhereOrNull(
                          (e) =>
                              e.wordPosition.row ==
                                  value.gridPosition.rowIndex &&
                              e.wordPosition.col ==
                                  value.gridPosition.columnIndex,
                        )
                        ?.copyWith(isClicked: true);
                    if (clickedLetter != null) {
                      setState(() {
                        lettersGrid = lettersGrid.map((e) {
                          if (e.wordPosition.col ==
                                  clickedLetter.wordPosition.col &&
                              e.wordPosition.row ==
                                  clickedLetter.wordPosition.row) {
                            return clickedLetter;
                          } else {
                            return e;
                          }
                        }).toList();
                      });
                    }

                    debugPrint(
                      'clicked cell --- row: ${value.gridPosition.rowIndex}, col: ${value.gridPosition.columnIndex}',
                    );
                  },
                  gridSize: widget.gridSize,
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
}
