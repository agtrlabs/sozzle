import 'package:go_router/go_router.dart';
import 'package:sozzle/src/home/home.dart';
import 'package:sozzle/src/level/view/game_board.dart';
import 'package:sozzle/src/level/view/game_page.dart';
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
          path: GameBoard.path,
          name: GameBoard.path,
          builder: (context, state) => const GamePage(),
        ),
      ],
    ),
  ],
);
