import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sozzle/src/game/view/game.dart';
import 'package:sozzle/src/home/home.dart';
import 'package:sozzle/src/splash/splash_page.dart';

enum AppRoute {
  home,
  splash,
  game,
}

final GoRouter router = GoRouter(
  routes: <GoRoute>[
    GoRoute(
      path: SplashPage.path,
      builder: (context, GoRouterState state) => const SplashPage(),
      routes: <GoRoute>[
        GoRoute(
          path: HomePage.path,
          builder: (context, GoRouterState state) => const HomePage(),
        ),
        GoRoute(
          path: Game.path,
          name: AppRoute.game.name,
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            fullscreenDialog: true,
            child: const Game(),
          ),
        ),
      ],
    ),
  ],
);
