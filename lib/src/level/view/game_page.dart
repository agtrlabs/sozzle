import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sozzle/src/level/bloc/game_play/game_play_bloc.dart';
import 'package:sozzle/src/level/view/game_board.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<GamePlayBloc>(context).add(LoadLevelData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<GamePlayBloc, GamePlayState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is GamePlayLoaded) {
              return GameBoard(levelData: state.levelData);
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
