// coverage:ignore-file
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sozzle/src/game_play/view/components/hint.dart';
import 'package:sozzle/src/home/home.dart';
import 'package:sozzle/src/theme/cubit/theme_cubit.dart';
import 'package:sozzle/src/user_stats/cubit/user_stats_cubit.dart';

class GamePlayHeader extends StatelessWidget {
  const GamePlayHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserStatsCubit, UserStatsState>(
      builder: (context, state) {
        final theme = context.watch<ThemeCubit>().state;
        return AppBar(
          elevation: 0,
          backgroundColor: theme.backgroundColor,
          leading: IconButton(
            icon: const Icon(Icons.home),
            color: theme.primaryTextColor,
            onPressed: () {
              context.go(HomePage.path);
            },
          ),
          centerTitle: true,
          title: Text(
            'Level ${state.progress.currentLevel}',
            style: TextStyle(color: theme.primaryTextColor),
          ),
          actions: const [Hint(), SizedBox(width: 16)],
        );
      },
    );
  }
}
