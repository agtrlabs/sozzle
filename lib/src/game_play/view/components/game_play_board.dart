import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grid_board/grid_board.dart';
import 'package:level_data/level_data.dart';
import 'package:sozzle/src/game_play/bloc/game_play_bloc.dart';
import 'package:sozzle/src/theme/cubit/theme_cubit.dart';

class GamePlayBoard extends StatelessWidget {
  const GamePlayBoard(this.levelData, {super.key});
  final LevelData levelData;

  @override
  Widget build(BuildContext context) {
    final theme = BlocProvider.of<ThemeCubit>(context).state;

    final gridSize = GridSize(levelData.boardWidth, levelData.boardHeight);

    final cels = levelData.boardData.map(
      (e) {
        return GridCell(
          gridCellChildMap: e.isNotEmpty
              ? {
                  GridCellStatus.initial: LetterBox(e),
                  GridCellStatus.selected: OpenLetterBox(e),
                }
              : {
                  GridCellStatus.initial: const NoLetterBox(),
                  GridCellStatus.selected: const NoLetterBox(),
                },
        );
      },
    ).toList();

    final controller = GridBoardController(
      gridBoardProperties: GridBoardProperties(
        gridSize: gridSize,
      ),
      cells: cels,
    );
    return BlocListener<GamePlayBloc, GamePlayState>(
      listener: (context, game) {
        if (game.state == GamePlayActualState.wordFound) {
          final indexes = game.revealedCells;
          for (final idx in indexes) {
            controller.updateCellStatus(idx, GridCellStatus.selected);
          }
        }
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 50,
        child: GridBoard(
          backgroundColor: theme.backgroundColor,
          controller: controller,
          gridSize: GridSize(levelData.boardWidth, levelData.boardHeight),
        ),
      ),
    );
  }
}

class LetterBox extends StatelessWidget {
  const LetterBox(this.letter, {super.key});
  final String? letter;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      key: ValueKey(letter),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        border: Border.all(),
      ),
      child: Container(),
    );
  }
}

class OpenLetterBox extends StatelessWidget {
  const OpenLetterBox(this.letter, {super.key});
  final String? letter;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      key: ValueKey(letter),
      decoration: BoxDecoration(
        color: Colors.blue[300],
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        border: Border.all(),
      ),
      child: FittedBox(
        child: Text(letter ?? ' '),
      ),
    );
  }
}

class NoLetterBox extends StatelessWidget {
  const NoLetterBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
