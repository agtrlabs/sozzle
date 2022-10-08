import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grid_board/grid_board.dart';
import 'package:sozzle/src/game_play/bloc/game_play_bloc.dart';
import 'package:sozzle/src/level/domain/level_data.dart';
import 'package:sozzle/src/theme/cubit/theme_cubit.dart';

class GamePlayBoard extends StatelessWidget {
  const GamePlayBoard(this.levelData, {super.key});
  final LevelData levelData;

  @override
  Widget build(BuildContext context) {
    final theme = BlocProvider.of<ThemeCubit>(context).state;
    final controller = GridBoardController(
      gridBoardProperties: GridBoardProperties(
        gridSize: GridSize(levelData.boardWidth, levelData.boardHeight),
      ),
      cells: levelData.boardData
          .map(
            (e) => GridCell(
              gridCellChildMap: e.isNotEmpty
                  ? {
                GridCellStatus.initial: LetterBox(e),
                GridCellStatus.selected: OpenLetterBox(e),
                    }
                  : {
                      GridCellStatus.initial: NoLetterBox(),
                      GridCellStatus.selected: NoLetterBox(),
                    },
              
            ),
          )
          .toList(),
    );
    return BlocListener<GamePlayBloc, GamePlayState>(
      listener: (context, game) {
        game.revealedCells.map(
            (idx) => controller.updateCellStatus(idx, GridCellStatus.selected));
      },
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: theme.backgroundColor,
          child: GridBoard(
            controller: controller,
            gridSize: GridSize(levelData.boardWidth, levelData.boardHeight),
          ),
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
      key: UniqueKey(),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(),
      ),
      child: FittedBox(
        child: Text(''),
        //fit: BoxFit.contain,
      ),
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
      key: UniqueKey(),
      decoration: BoxDecoration(
        color: Colors.greenAccent,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
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
