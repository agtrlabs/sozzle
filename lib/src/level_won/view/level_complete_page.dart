import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:level_data/level_data.dart';
import 'package:rive/rive.dart';
import 'package:sozzle/core/common/widgets/sozzle_app_bar.dart';
import 'package:sozzle/core/res/media.dart';
import 'package:sozzle/src/game_play/view/game_play_page.dart';
import 'package:sozzle/src/home/view/home_page.dart';
import 'package:sozzle/src/level_won/level_won.dart';

class LevelCompletePage extends StatefulWidget {
  const LevelCompletePage({required this.levelData, super.key});

  static const path = '/won';
  final LevelData levelData;

  @override
  State<LevelCompletePage> createState() => _LevelCompletePageState();
}

class _LevelCompletePageState extends State<LevelCompletePage> {
  late File file;
  late RiveWidgetController controller;

  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    initRive();
  }

  Future<void> initRive() async {
    file = (await File.asset(Media.lake, riveFactory: Factory.rive))!;
    controller = RiveWidgetController(file);
    setState(() => isInitialized = true);
  }

  @override
  void dispose() {
    file.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: SozzleAppBar(
        leading: IconButton(
          icon: const Icon(Icons.home),
          color: Colors.white,
          onPressed: () {
            context.go(HomePage.path);
          },
        ),
      ),
      body: Builder(
        builder: (scaffoldContext) {
          return Stack(
            children: [
              if (!isInitialized)
                const Center(child: CircularProgressIndicator())
              else
                RiveWidget(controller: controller, fit: Fit.cover),
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
                                  context.go(
                                    '${GamePlayPage.path}/${widget.levelData.levelId + 1}',
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
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
