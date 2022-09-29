import 'package:sozzle/src/user_stats/domain/user_progress_data.dart';

abstract class IUserStatsRepository {
  Future<UserProgressData> getUserProgressData();
  Future<void> saveUserProgressData();
}
