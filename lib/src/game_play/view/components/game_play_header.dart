// coverage:ignore-file
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sozzle/core/common/widgets/scorecard.dart';
import 'package:sozzle/src/game_play/view/components/crossword_clues_button.dart';
import 'package:sozzle/src/game_play/view/components/hint.dart';
import 'package:sozzle/src/home/home.dart';
import 'package:sozzle/src/theme/cubit/theme_cubit.dart';
import 'package:sozzle/src/user_stats/cubit/user_stats_cubit.dart';

class GamePlayHeader extends StatelessWidget {
  const GamePlayHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraint) {
        final renderColumn = constraint.maxWidth < 731;
        return BlocBuilder<UserStatsCubit, UserStatsState>(
          builder: (context, state) {
            final theme = context.watch<ThemeCubit>().state;
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ).copyWith(top: renderColumn ? 16 : 32),
              child: switch (renderColumn) {
                true => MobileHeader(state: state, theme: theme),
                _ => ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: DesktopHeader(state: state, theme: theme),
                  ),
              },
            );
          },
        );
      },
    );
  }
}

class DesktopHeader extends StatelessWidget {
  const DesktopHeader({required this.state, required this.theme, super.key});

  final UserStatsState state;
  final ThemeState theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Scorecard(
            level: state.progress.currentLevel,
            failedAttempts: '0',
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CrosswordCluesButton(),
            IconButton(
              icon: const Icon(Icons.home),
              iconSize: 30,
              color: theme.primaryTextColor,
              onPressed: () {
                context.go(HomePage.path);
              },
            ),
            const Hint(),
          ],
        ),
      ],
    );
  }
}

class MobileHeader extends StatelessWidget {
  const MobileHeader({required this.state, required this.theme, super.key});

  final UserStatsState state;
  final ThemeState theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Scorecard(level: state.progress.currentLevel, failedAttempts: '0'),
        Row(
          children: [
            const CrosswordCluesButton(),
            IconButton(
              icon: const Icon(Icons.home),
              iconSize: 30,
              color: theme.primaryTextColor,
              onPressed: () {
                context.go(HomePage.path);
              },
            ),
            const Hint(),
          ],
        ),
      ],
    );
  }
}
