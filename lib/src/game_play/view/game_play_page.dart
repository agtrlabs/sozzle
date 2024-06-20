// coverage:ignore-file
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:level_data/level_data.dart';
import 'package:sozzle/src/audio/domain/i_audio_controller.dart';
import 'package:sozzle/src/game_play/game_play.dart';
import 'package:sozzle/src/game_play/view/components/game_loader.dart';
import 'package:sozzle/src/level/domain/i_level_repository.dart';
import 'package:sozzle/src/level_won/view/level_complete_page.dart';
import 'package:sozzle/src/theme/theme.dart';
import 'package:sozzle/src/user_stats/cubit/user_stats_cubit.dart';

class GamePlayPage extends StatelessWidget {
  const GamePlayPage({required this.levelID, super.key});

  static const path = '/play';
  final int levelID;

  @override
  Widget build(BuildContext context) {
    final theme = BlocProvider.of<ThemeCubit>(context).state;
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: Center(
        child: GameLoader(
          future: RepositoryProvider.of<ILevelRepository>(context)
              .getLevel(levelID),
          builder: (BuildContext context, AsyncSnapshot<LevelData> snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const CircularProgressIndicator();
            }
            if (!snapshot.hasData) {
              return const Text('Ops an error!');
            } else {
              final bloc = GamePlayBloc(
                levelData: snapshot.data!,
                audio: RepositoryProvider.of<IAudioController>(context),
              );
              debugPrint(bloc.levelData.words.toString());
              return BlocProvider<GamePlayBloc>(
                create: (context) => bloc..add(const GamePlayInitialEvent()),
                child: BlocListener<GamePlayBloc, GamePlayState>(
                  listener: (context, state) {
                    if (state.state == GamePlayActualState.allFound) {
                      context.read<UserStatsCubit>().advanceLevelUp();
                      final levelData = bloc.levelData;
                      context.go(LevelCompletePage.path, extra: levelData);
                    }
                  },
                  child: Flex(
                    direction: Axis.vertical,
                    children: [
                      const GamePlayHeader(),
                      Flexible(flex: 4, child: GamePlayBoard(snapshot.data!)),
                      Flexible(flex: 3, child: GamePlayLetters(snapshot.data!)),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
