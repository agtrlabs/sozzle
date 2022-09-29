//import 'package:http/http.dart' as http;
import 'package:sozzle/src/apploader/apploader.dart';
import 'package:sozzle/src/level/domain/i_level_repository.dart';
import 'package:sozzle/src/level/domain/level_data.dart';
import 'package:sozzle/src/level/domain/user_progress_data.dart';

class MockApploaderRepository implements IApploaderRepository {
  MockApploaderRepository(this.levelRepository);

  LevelList list = LevelList([]);

  @override
  ILevelRepository levelRepository;

  @override
  Future<LevelList> getLevels() async {
    // TODO(akyunus): get data online
    list.levels.addAll([
      LevelData(
        levelId: 1,
        words: ['SAW', 'WASP', 'SWAP', 'NAP', 'SPAWN'],
        boardHeight: 5,
        boardWidth: 5,
        boardData: [
          'W',
          '',
          'S',
          'A',
          'W',
          'A',
          '',
          'W',
          '',
          '',
          'S',
          'P',
          'A',
          'W',
          'N',
          'P',
          '',
          'P',
          '',
          'A',
          '',
          '',
          '',
          '',
          'P'
        ],
      ),
      LevelData(
        levelId: 2,
        words: [
          'RIFLE',
          'FLIRT',
          'FIRE',
          'LEFT',
          'TIRE',
          'REFIT',
          'FILTER',
          'RELIT',
          'TIER',
        ],
        boardHeight: 8,
        boardWidth: 9,
        boardData: [
          '',
          'R',
          'I',
          'F',
          'L',
          'E',
          '',
          '',
          '',
          '',
          '',
          '',
          'I',
          '',
          '',
          '',
          '',
          '',
          'R',
          '',
          'F',
          'L',
          'I',
          'R',
          'T',
          '',
          '',
          'E',
          '',
          '',
          'T',
          '',
          'E',
          '',
          '',
          '',
          'F',
          'I',
          'R',
          'E',
          '',
          'L',
          'E',
          'F',
          'T',
          'I',
          '',
          '',
          'R',
          '',
          'I',
          '',
          '',
          'I',
          'T',
          '',
          '',
          '',
          '',
          'T',
          'I',
          'R',
          'E',
          '',
          '',
          '',
          '',
          '',
          '',
          '',
          '',
          'R',
        ],
      ),
    ]);
    /*LevelData(boardData: [], levelId: 2, words: []),
      LevelData(boardData: [], levelId: 3, words: []),
      LevelData(boardData: [], levelId: 4, words: []),*/

    return list;
  }

  @override
  Future<UserProgressData> getUserProgressData() async {
    return UserProgressData(currentLevel: 1);
  }

  @override
  Stream<double> saveData() async* {
    /// progress percent
    var progress = 0.0;
    yield progress;
    final increment = 1 / list.levels.length;

    for (final level in list.levels) {
      await levelRepository.setLevel(level);
      //update percent
      progress += increment;
      //level save to file
      yield progress < 1 ? progress : 0.99;
    }

    yield 1;
  }
}
