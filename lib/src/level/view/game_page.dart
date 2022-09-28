import 'package:flutter/material.dart';
import 'package:sozzle/services/mock_server.dart';
import 'package:sozzle/src/level/models/level.dart';
import 'package:sozzle/src/level/view/game_board.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late final Future<Map<String, dynamic>> _mockData;

  @override
  void initState() {
    super.initState();
    _mockData = MockServer().loadAsset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _mockData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData && snapshot.data != null) {
                final data = snapshot.data!;
                final levelData = LevelData.fromMap(
                  data,
                );

                return GameBoard(
                  levelData: levelData,
                );
              }

              if (snapshot.hasError) {
                return const Center(
                  child: Text('Something went wrong!'),
                );
              }

              return const Center(
                child: Text('No data available.'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
