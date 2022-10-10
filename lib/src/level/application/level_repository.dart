import 'package:localstore/localstore.dart';
import 'package:sozzle/src/level/domain/i_level_repository.dart';
import 'package:sozzle/src/level/domain/level_data.dart';

/// Save and load [LevelData] by levelId from disk using [Localstore]
class LevelRepository implements ILevelRepository {
  final _db = Localstore.instance;

  @override
  Future<LevelData> getLevel(int levelId) async {
    // TODO(any): error handling
    final data = await _db.collection('levels').doc('$levelId').get();
    return LevelData.fromMap(data!);
  }

  @override
  Future<bool> setLevel(LevelData level) async {
    final data = level.toMap();
    await _db.collection('levels').doc('${level.levelId}').set(data);
    return true;
  }
}
