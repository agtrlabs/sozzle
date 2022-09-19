import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sozzle/src/apploader/cubit/apploader_cubit.dart';
import 'package:sozzle/src/theme/cubit/theme_cubit.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  static const String path = '/';

  @override
  Widget build(BuildContext context) {
    final apploader = context.read<ApploaderCubit>();
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: state.backgroundColor,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sozzle',
                  style: TextStyle(
                    color: state.primaryTextColor,
                    fontSize: 24,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: BlocBuilder<ApploaderCubit, ApploaderState>(
                    builder: (context, state) {
                      if (state is ApploaderStateLoadingPuzzles) {
                        return LinearProgressIndicator(
                          value: state.percent / 100,
                        );
                      } else if (state is ApploaderStateLoadingUserData) {
                        return LinearProgressIndicator(
                          value: state.percent / 100,
                        );
                      } else if (state is ApploaderStateLoaded) {
                        return TextButton(
                          child: const Text(
                            'Tap to Start',
                            style: TextStyle(fontSize: 24),
                          ),
                          onPressed: () {
                            GoRouter.of(context).replace('/home');
                          },
                        );
                      }
                      apploader.updatePuzzleData();
                      return Container();
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
