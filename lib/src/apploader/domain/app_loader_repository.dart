import 'package:sozzle/core/domain/level_data.dart';
import 'package:sozzle/core/domain/user_progress_data.dart';

/// checks updates, loads updated data, saves to local
abstract class AppLoaderRepository {
  Future<LevelList> getLevels();
  Future<UserProgressData> getUserProgressData();
  Stream<double> saveData();
}
