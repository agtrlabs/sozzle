import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sozzle/src/common/border_elevated_button.dart';
import 'package:sozzle/src/home/view/play_button.dart';
import 'package:sozzle/src/theme/theme.dart';
import 'package:sozzle/src/user_stats/user_stats.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static const String path = 'home';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, theme) => Scaffold(
        backgroundColor: theme.backgroundColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Sozzle Home Page',
                style: TextStyle(
                  color: theme.primaryTextColor,
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            BlocBuilder<UserStatsCubit, UserStatsState>(
              builder: (context, state) {
                return PlayButton(state.progress.currentLevel.toString());
              },
            ),
            const SizedBox(
              height: 20,
            ),
            BorderElevatedButton(
              route: '/settings',
              text: 'Settings',
              backgroundColor: theme.backgroundColor,
              borderColor: theme.primaryTextColor,
              textColor: theme.primaryTextColor,
            ),
          ],
        ),
      ),
    );
  }
}
