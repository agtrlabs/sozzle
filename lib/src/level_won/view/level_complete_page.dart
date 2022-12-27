import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:level_data/level_data.dart';
import 'package:rive/rive.dart';
import 'package:sozzle/core/common/widgets/sozzle_app_bar.dart';
import 'package:sozzle/src/game_play/view/game_play_page.dart';
import 'package:sozzle/src/home/view/home_page.dart';
import 'package:sozzle/src/level_won/level_won.dart';

class LevelCompletePage extends StatelessWidget {
  const LevelCompletePage({super.key, required this.levelData});

  static const path = '/won';
  final LevelData levelData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: SozzleAppBar(
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            context.go(HomePage.path);
          },
        ),
      ),
      body: Builder(
        builder: (scaffoldContext) {
          return Stack(
            children: [
              const RiveAnimation.asset(
                'assets/rive/small_lake_on_a_rainy_day.riv',
                fit: BoxFit.cover,
              ),
              Center(
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(scaffoldContext).size.width * 0.7,
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            const SizedBox(
                              height: 25,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: CollectRewardsButton(
                                onPressed: () {
                                  // TODO(CollectRewards): Implement this
                                },
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 45),
                              child: NextLevelButton(
                                onPressed: () {
                                  // TODO(NextLevel): Implement this
                                  context.go(
                                    '${GamePlayPage.path}/${levelData.levelId + 1}',
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
