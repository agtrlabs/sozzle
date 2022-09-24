import 'package:sozzle/core/domain/level_data.dart';

// load/save level
abstract class ILevelRepository {
  Future<LevelData> getLevel(int id);
  Future<bool> setLevel(LevelData level);
}
