import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sozzle/src/game_play/game_play.dart';
import 'package:sozzle/src/level/domain/i_level_repository.dart';
import 'package:sozzle/src/level/domain/level_data.dart';

class GamePlayPage extends StatelessWidget {
  const GamePlayPage({super.key, required this.levelID});
  static const path = 'play';
  final int levelID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: RepositoryProvider.of<ILevelRepository>(context)
              .getLevel(levelID),
          builder: (BuildContext context, AsyncSnapshot<LevelData> snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const CircularProgressIndicator();
            }
            if (!snapshot.hasData) {
              return const Text('Ops an error!');
            } else {
              return BlocProvider(
                create: (_) => GamePlayBloc(levelData: snapshot.data!),
                child: Column(
                  children: const [
                    GamePlayHeader(),
                    GamePlayBoard(),
                    GamePlayLetters(),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
