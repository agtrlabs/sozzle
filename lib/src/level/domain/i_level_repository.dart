// coverage:ignore-file
import 'package:level_data/level_data.dart';

// load/save leveldata
abstract class ILevelRepository {
  Future<LevelData> getLevel(int id);
  Future<void> setLevel(LevelData level);
}
