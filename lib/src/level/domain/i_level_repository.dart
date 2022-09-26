import 'package:sozzle/src/level/domain/level_data.dart';

// load/save leveldata
abstract class ILevelRepository {
  Future<LevelData> getLevel(int id);
  Future<void> setLevel(LevelData level);
}
