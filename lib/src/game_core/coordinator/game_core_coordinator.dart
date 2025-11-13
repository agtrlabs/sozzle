import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_core/game_core.dart';
import 'package:go_router/go_router.dart';
import 'package:sozzle/src/game_play/view/game_play_page.dart';
import 'package:sozzle/src/home/view/home_page.dart';
import 'package:sozzle/src/level_won/view/level_complete_page.dart';

/// Coordinates navigation based on GameCore state changes.
///
/// This widget listens to the [GameCoreBloc] and triggers navigation
/// when the game state changes (e.g., level won -> navigate to won page).
///
/// It wraps the current route's child widget and acts as a shell,
/// allowing the entire app to react to game state changes.
class GameCoreCoordinator extends StatelessWidget {
  /// Creates a [GameCoreCoordinator].
  const GameCoreCoordinator({
    required this.child,
    super.key,
  });

  /// The child widget (current route).
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<GameCoreBloc, GameCoreState>(
      listener: (context, state) {
        final currentLocation = GoRouterState.of(context).uri.toString();

        // Prevent navigation loops by checking current location
        switch (state) {
          case GameCoreLevelWon(:final level):
            // Navigate to level complete page when level is won
            if (!currentLocation.startsWith(LevelCompletePage.path)) {
              context.go(
                LevelCompletePage.path,
                extra: level.data,
              );
            }
          case GameCoreIdle():
            // Navigate to home when game is idle
            // (unless we're already there or on settings/splash)
            if (!currentLocation.startsWith(HomePage.path) &&
                !currentLocation.contains('/settings') &&
                !currentLocation.contains('/splash')) {
              context.go(HomePage.path);
            }
          case GameCorePlaying(:final level):
            // Navigate to game play page when playing
            final expectedPath = '${GamePlayPage.path}/${level.levelId}';
            if (currentLocation != expectedPath) {
              context.go(expectedPath);
            }
          case GameCoreError(:final message):
            // Show error snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          // For other states (Initial, LoadingLevel), don't navigate
          case GameCoreInitial():
          case GameCoreLoadingLevel():
            break;
        }
      },
      child: child,
    );
  }
}
