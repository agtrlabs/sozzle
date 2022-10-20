// load the game

import 'package:flutter/material.dart';
import 'package:level_data/level_data.dart';

class GameLoader extends FutureBuilder<LevelData> {
  const GameLoader({super.key, required super.builder, super.future});
}
