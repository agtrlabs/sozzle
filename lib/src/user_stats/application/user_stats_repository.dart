import 'package:localstore/localstore.dart';
import 'package:sozzle/src/user_stats/user_stats.dart';

class UserStatsRepository implements IUserStatsRepository {
  final _db = Localstore.instance;

  @override
  Future<UserProgressData> getCurrent() async {
    final data = await _db.collection('stats').doc('current').get();
    // create initial ProgressData
    if (data == null) {
      final initialProgres = UserProgressData(currentLevel: 1);
      await save(initialProgres);
      return initialProgres;
    }
    return UserProgressData.fromMap(data!);
  }

  @override
  Future<void> save(UserProgressData progressData) async {
    final data = progressData.toMap();
    await _db.collection('levels').doc('current').set(data);
    return;
  }
}
