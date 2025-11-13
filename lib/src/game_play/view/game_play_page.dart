// coverage:ignore-file
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_core/game_core.dart';
import 'package:sozzle/src/audio/domain/i_audio_controller.dart';
import 'package:sozzle/src/game_play/game_play.dart';
import 'package:sozzle/src/theme/theme.dart';

class GamePlayPage extends StatelessWidget {
  const GamePlayPage({required this.levelID, super.key});

  static const path = '/play';
  final int levelID;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return Scaffold(
          backgroundColor: themeState.backgroundColor,
          body: Center(
            child: BlocBuilder<GameCoreBloc, GameCoreState>(
              builder: (context, gameCoreState) {
                if (gameCoreState is GameCoreLoadingLevel) {
                  return const CircularProgressIndicator();
                }

                if (gameCoreState is! GameCorePlaying) {
                  return const Text('Loading level...');
                }

                final level = gameCoreState.level;
                final bloc = GamePlayBloc(
                  levelData: level.data,
                  audio: RepositoryProvider.of<IAudioController>(context),
                );

                return BlocProvider<GamePlayBloc>(
                  create: (context) => bloc..add(const GamePlayInitialEvent()),
                  child: BlocListener<GamePlayBloc, GamePlayState>(
                    listener: (context, state) {
                      if (state.actualState == GamePlayActualState.allFound) {
                        // Notify GameCore that the level is completed
                        context
                            .read<GameCoreBloc>()
                            .add(const LevelCompleted());
                      }
                    },
                    child: Flex(
                      direction: Axis.vertical,
                      children: [
                        const GamePlayHeader(),
                        const SizedBox(height: 10),
                        Flexible(
                          flex: 4,
                          child: GamePlayBoard(level.data),
                        ),
                        Flexible(
                          flex: 3,
                          child: GamePlayLetters(level.data),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
