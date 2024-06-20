import 'package:localstore/localstore.dart';
import 'package:sozzle/core/environment.dart';
import 'package:sozzle/src/game_play/domain/entities/booster.dart';
import 'package:sozzle/src/user_stats/user_stats.dart';

class UserStatsRepository implements IUserStatsRepository {
  final _db = Localstore.instance;

  @override
  Future<UserProgressData> getCurrent() async {
    final data = await _db.collection('stats').doc('current').get();
    // create initial ProgressData
    if (data == null) {
      final initialProgress = switch (Environment.instance.type) {
        EnvironmentType.PRODUCTION => UserProgressData(currentLevel: 1),
        _ => UserProgressData(
            currentLevel: 1,
            boosters: [const UseAHint(boosterCount: 1)],
            points: 1000,
          ),
      };
      await save(initialProgress);
      return initialProgress;
    }
    // TODO(REMOVE): Remove this code before production or after we add levels
    if ((data['currentLevel'] as num).toInt() > 2) {
      await _db.collection('stats').delete();
    }
    var progress = UserProgressData.fromMap(data);
    if (Environment.instance.type == EnvironmentType.PRODUCTION) {
      return progress;
    }
    if (progress.boosters.isEmpty ||
        progress.boosters.whereType<UseAHint>().first.boosterCount < 1) {
      progress.boosters.removeWhere((booster) => booster is UseAHint);
      progress.boosters.add(const UseAHint(boosterCount: 1));
    }
    if (progress.points < 1) {
      progress = progress.copyWith(points: 1000);
    }
    return progress;
  }

  @override
  Future<void> save(UserProgressData progressData) async {
    final data = progressData.toMap();
    await _db.collection('stats').doc('current').set(data);
    return;
  }
}
