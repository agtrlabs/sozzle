import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sozzle/src/theme/cubit/theme_cubit.dart';
import 'package:sozzle/src/user_stats/cubit/user_stats_cubit.dart';

class GamePlayHeader extends StatelessWidget {
  const GamePlayHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserStatsCubit, UserStatsState>(
      builder: (context, state) {
        final theme = BlocProvider.of<ThemeCubit>(context).state;
        return AppBar(
          backgroundColor: theme.backgroundColor,
          leading: IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              GoRouter.of(context).replace('/home');
            },
          ),
          centerTitle: true,
          title: Text('Level ${state.progress.currentLevel}'),
        );
      },
    );
  }
}
