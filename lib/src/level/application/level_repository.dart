import 'dart:developer';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:level_data/level_data.dart';
import 'package:level_generator/level_generator.dart';
import 'package:localstore/localstore.dart';
import 'package:sozzle/src/level/domain/i_level_repository.dart';

/// Save and load [LevelData] by levelId from disk using [Localstore]
class LevelRepository implements ILevelRepository {
  LevelRepository({required LevelGenerator levelGenerator})
      : _levelGenerator = levelGenerator;

  final LevelGenerator _levelGenerator;
  final _db = Localstore.instance;

  @override
  Future<LevelData> getLevel(int levelId) async {
    try {
      final data = await _db.collection('levels').doc('$levelId').get();
      if (data == null) {
        log(
          'Level $levelId not found in localstore, generating new level',
          name: 'LevelRepository.getLevel',
        );
        final levelData = await _levelGenerator.generateLevel(level: levelId);
        log(
          'Generated level $levelId: ${levelData.toMap()}',
          name: 'LevelRepository.getLevel',
        );
        await setLevel(levelData);
        log(
          'Saved generated level $levelId to localstore',
          name: 'LevelRepository.getLevel',
        );
        return levelData;
      }

      return LevelData.fromMap(data);
    } on Exception catch (e, s) {
      log(
        'Error loading level $levelId: $e',
        name: 'LevelRepository.getLevel',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  @override
  Future<List<LevelData>> getLevels() async {
    final data = await _db.collection('levels').get();
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(data.values)
        .map(LevelData.fromMap)
        .toList(growable: false);
  }

  @override
  Future<bool> hasLevel(int levelId) async {
    final data = await _db.collection('levels').doc('$levelId').get();
    return data != null;
  }

  Future<void> deleteLevels() async {
    log('Deleting all levels', name: 'LevelRepository.deleteLevels');

    await HydratedBloc.storage.clear();
    await _db.collection('levels').delete();
  }

  @override
  Future<bool> setLevel(LevelData level) async {
    log('Saving level ${level.levelId}', name: 'LevelRepository.setLevel');
    final data = level.toMap();
    await _db.collection('levels').doc('${level.levelId}').set(data);
    return true;
  }
}
