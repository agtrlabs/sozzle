import 'package:go_router/go_router.dart';
import 'package:level_data/level_data.dart';
import 'package:sozzle/src/game_play/game_play.dart';
import 'package:sozzle/src/home/home.dart';
import 'package:sozzle/src/level_won/view/level_complete_page.dart';
import 'package:sozzle/src/settings/view/settings_page.dart';
import 'package:sozzle/src/splash/splash_page.dart';

final GoRouter router = GoRouter(
  initialLocation: SplashPage.path,
  routes: <GoRoute>[
    GoRoute(
      path: SplashPage.path,
      builder: (context, GoRouterState state) => const SplashPage(),
    ),
    GoRoute(
      path: HomePage.path,
      builder: (context, GoRouterState state) => const HomePage(),
    ),
    GoRoute(
      path: SettingsPage.path,
      builder: (context, GoRouterState state) => const SettingsPage(),
    ),
    GoRoute(
      path: '${GamePlayPage.path}/:levelId',
      builder: (context, GoRouterState state) => GamePlayPage(
        levelID: int.parse(state.pathParameters['levelId']!),
      ),
    ),
    GoRoute(
      path: LevelCompletePage.path,
      builder: (context, GoRouterState state) => LevelCompletePage(
        levelData: state.extra! as LevelData,
      ),
    ),
  ],
);
