import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sozzle/src/theme/theme.dart';
import 'package:sozzle/src/user_stats/user_stats.dart';

class WinPage extends StatelessWidget {
  const WinPage({super.key});
  static const String path = '/win';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, theme) {
        return BlocBuilder<UserStatsCubit, UserStatsState>(
          builder: (context, stats) {
            return Scaffold(
              backgroundColor: theme.backgroundColor,
              body: const WinScreen(),
            );
          },
        );
      },
    );
  }
}

class WinScreen extends StatelessWidget {
  const WinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(
        Icons.golf_course_outlined,
        size: 32,
      ),
    );
  }
}
