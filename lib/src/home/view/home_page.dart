import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sozzle/src/common/border_elevated_button.dart';
import 'package:sozzle/src/theme/theme.dart';
import 'package:sozzle/src/user_stats/user_stats.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static const String path = 'home';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) => Scaffold(
        backgroundColor: state.backgroundColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Sozzle Home Page',
                style: TextStyle(
                  color: state.primaryTextColor,
                  fontSize: 24,
                ),
              ),
            ),
            BlocBuilder<UserStatsCubit, UserStatsState>(
              builder: (context, state) {
                return TextButton(
                  onPressed: () {
                    // TODO(any): route to game play
                    context.read<UserStatsCubit>().advanceLevelUp();
                  },
                  child: Text('Current Level: ${state.progress.currentLevel}'),
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            BorderElevatedButton(
              route: '/home/settings',
              text: 'Settings',
              backgroundColor: Colors.blue,
              borderColor: Colors.white,
              textColor: state.primaryTextColor,
            ),
          ],
        ),
      ),
    );
  }
}

class PlayButton extends StatelessWidget {
  const PlayButton(this.levelId, {super.key});
  final String levelId;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        GoRouter.of(context).replace('/play/$levelId');
      },
      child: Text('PLAY Level: $levelId'),
    );
  }
}
