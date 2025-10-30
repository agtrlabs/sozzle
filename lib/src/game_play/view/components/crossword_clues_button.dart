// coverage:ignore-file
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sozzle/src/game_play/bloc/game_play_bloc.dart';
import 'package:sozzle/src/game_play/view/components/crossword_clues_dialog.dart';
import 'package:sozzle/src/theme/theme.dart';

/// A button that opens a dialog showing crossword clues for the current level.
class CrosswordCluesButton extends StatelessWidget {
  const CrosswordCluesButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeCubit>().state;
    final levelData = context.read<GamePlayBloc>().levelData;

    // Don't show button if there are no crosswords
    if (levelData.crosswords.isEmpty) {
      return const SizedBox.shrink();
    }

    return Tooltip(
      message: 'View crossword clues',
      child: IconButton(
        icon: const Icon(Icons.view_list_rounded),
        iconSize: 30,
        color: theme.primaryTextColor,
        onPressed: () {
          showDialog<void>(
            context: context,
            builder: (dialogContext) => BlocProvider.value(
              value: context.read<GamePlayBloc>(),
              child: CrosswordCluesDialog(
                levelData: levelData,
              ),
            ),
          );
        },
      ),
    );
  }
}
