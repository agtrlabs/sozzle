import 'package:circular_pattern/circular_pattern.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:grid_board/grid_board.dart';
import 'package:sozzle/src/game/model/word_list.dart' as word;

class GameBoard extends StatefulWidget {
  const GameBoard({
    super.key,
    required this.wordList,
  });

  final word.WordList wordList;

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  late List<word.LetterGrid> lettersGrid;
  late GridBoardController? _controller;
  late GridSize _gridSize;

  @override
  void initState() {
    super.initState();
    lettersGrid = widget.wordList.words
        .expand(
          (word) => word.letters,
        )
        .toList();
    _gridSize =
        GridSize(widget.wordList.grid.maxSize, widget.wordList.grid.maxSize);
  }

  @override
  void dispose() {
    super.dispose();
    // _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller = GridBoardController(
      gridBoardProperties: GridBoardProperties(
        gridSize: _gridSize,
      ),
      cells: List.generate(_gridSize.cellCount, (index) {
        final letter = lettersGrid.firstWhereOrNull(
          (e) =>
              ((e.wordPosition.col * widget.wordList.grid.maxSize) +
                  e.wordPosition.row) ==
              index,
        );

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
            SizedBox(
              height: _gridHeight,
              width: _gridHeight,
              child: _buildBoard(),
            ),
            SizedBox(
              height: _consoleHeight,
              child: CircularPattern(
                onStart: () {
                  // called when started drawing a new pattern
                },
                onComplete: (List<PatternDot> input) {
                  final selectedWord =
                      input.map((e) => e.value).join().toLowerCase();
                  debugPrint('selectd word: $selectedWord');
                  final matchedWord = widget.wordList.words.firstWhereOrNull(
                    (word) => word.name.toLowerCase() == selectedWord,
                  );
                  if (matchedWord != null) {
                    for (final letter in matchedWord.letters) {
                      lettersGrid = lettersGrid.map((e) {
                        if (e.wordPosition.col == letter.wordPosition.col &&
                            e.wordPosition.row == letter.wordPosition.row) {
                          return letter.copyWith(isClicked: true);
                        } else {
                          return e;
                        }
                      }).toList();
                    }
                    setState(() {});
                  }

                  final isFinished =
                      lettersGrid.every((element) => element.isClicked);
                  debugPrint('is finished: $isFinished');
                  if (isFinished) {
                    debugPrint('STRIIIIIIIIIIIIIKKKKKKEEEEEEEEEEE');
                  }
                },
                dots: widget.wordList.letters
                    .map(
                      (l) => PatternDot(value: l),
                    )
                    .toList(),
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
      onTap: (value) {
        final clickedLetter = lettersGrid
            .firstWhereOrNull(
              (e) =>
                  e.wordPosition.row == value.gridPosition.rowIndex &&
                  e.wordPosition.col == value.gridPosition.columnIndex,
            )
            ?.copyWith(isClicked: true);
        if (clickedLetter != null) {
          setState(() {
            lettersGrid = lettersGrid.map((e) {
              if (e.wordPosition.col == clickedLetter.wordPosition.col &&
                  e.wordPosition.row == clickedLetter.wordPosition.row) {
                return clickedLetter;
              } else {
                return e;
              }
            }).toList();
          });
        }
      },
      gridSize: _gridSize,
    );
  }
}
