import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sozzle/src/game_play/game_play.dart';
import 'package:sozzle/src/level/domain/level_data.dart';

class GamePlayPage extends StatelessWidget {
  const GamePlayPage({super.key, required this.levelData});
  final LevelData levelData;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GamePlayBloc(levelData: levelData),
      child: Column(
        children: const [
          GamePlayHeader(),
          GamePlayBoard(),
          GamePlayLetters(),
        ],
      ),
    );
  }
}
