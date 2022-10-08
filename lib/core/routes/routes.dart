import 'package:go_router/go_router.dart';
import 'package:sozzle/src/game_play/game_play.dart';
import 'package:sozzle/src/home/home.dart';
import 'package:sozzle/src/settings/view/settings_page.dart';
import 'package:sozzle/src/splash/splash_page.dart';

final GoRouter router = GoRouter(
  routes: <GoRoute>[
    GoRoute(
      path: SplashPage.path,
      builder: (context, GoRouterState state) => const SplashPage(),
      routes: <GoRoute>[
        GoRoute(
          path: HomePage.path,
          builder: (context, GoRouterState state) => const HomePage(),
          routes: <GoRoute>[
            GoRoute(
              path: SettingsPage.path,
              builder: (context, GoRouterState state) => const SettingsPage(),
            ),
          ],
        ),
        GoRoute(
          path: '${GamePlayPage.path}/:levelId',
          builder: (context, GoRouterState state) => GamePlayPage(
            levelID: int.parse(state.params['levelId']!),
          ),
        ),
      ],
    ),
  ],
);
