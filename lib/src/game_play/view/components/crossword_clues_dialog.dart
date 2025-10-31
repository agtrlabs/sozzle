// coverage:ignore-file
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:level_data/level_data.dart';
import 'package:sozzle/src/game_play/bloc/game_play_bloc.dart';
import 'package:sozzle/src/theme/theme.dart';

/// A dialog that displays crossword clues organized by direction (Across/Down).
class CrosswordCluesDialog extends StatelessWidget {
  const CrosswordCluesDialog({
    required this.levelData,
    super.key,
  });

  final LevelData levelData;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeCubit>().state;
    final size = MediaQuery.of(context).size;

    // Responsive sizing
    final dialogWidth = size.width > 600 ? 500.0 : size.width * 0.9;
    final dialogHeight = size.height > 700 ? 600.0 : size.height * 0.8;

    // Separate and sort clues by direction
    final acrossClues = levelData.crosswords.values
        .where((c) => c.direction == CrossWordDirection.across)
        .toList()
      ..sort((a, b) => a.directionIndex.compareTo(b.directionIndex));

    final downClues = levelData.crosswords.values
        .where((c) => c.direction == CrossWordDirection.down)
        .toList()
      ..sort((a, b) => a.directionIndex.compareTo(b.directionIndex));

    return Dialog(
      backgroundColor: theme.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: dialogWidth,
        height: dialogHeight,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Crossword Clues',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryTextColor,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: theme.primaryTextColor,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Clues list
            Expanded(
              child: BlocBuilder<GamePlayBloc, GamePlayState>(
                builder: (context, state) {
                  final bloc = context.read<GamePlayBloc>();

                  return ListView(
                    children: [
                      // Across clues
                      if (acrossClues.isNotEmpty) ...[
                        Text(
                          'ACROSS',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryTextColor,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...acrossClues.map(
                          (clue) => _ClueItem(
                            clue: clue,
                            theme: theme,
                            isFound: bloc.foundWords
                                .contains(clue.word.toUpperCase()),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Down clues
                      if (downClues.isNotEmpty) ...[
                        Text(
                          'DOWN',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryTextColor,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...downClues.map(
                          (clue) => _ClueItem(
                            clue: clue,
                            theme: theme,
                            isFound: bloc.foundWords
                                .contains(clue.word.toUpperCase()),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Individual clue item widget.
class _ClueItem extends StatelessWidget {
  const _ClueItem({
    required this.clue,
    required this.theme,
    required this.isFound,
  });

  final Crossword clue;
  final ThemeState theme;
  final bool isFound;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Clue number
          SizedBox(
            width: 40,
            child: Text(
              '${clue.directionIndex}.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isFound
                    ? theme.primaryTextColor.withValues(alpha: 0.5)
                    : theme.primaryTextColor,
              ),
            ),
          ),

          // Clue definition and word info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Definition
                Text(
                  clue.definition ?? 'No definition available',
                  style: TextStyle(
                    fontSize: 15,
                    color: isFound
                        ? theme.primaryTextColor.withValues(alpha: 0.5)
                        : theme.primaryTextColor,
                    decoration: isFound ? TextDecoration.lineThrough : null,
                  ),
                ),

                // Word length hint and found indicator
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '(${clue.word.length} letters)',
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.primaryTextColor.withValues(alpha: 0.6),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    if (isFound) ...[
                      const SizedBox(width: 8),
                      Icon(
                        Icons.check_circle,
                        size: 16,
                        color: Colors.green.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        clue.word,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.green.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
