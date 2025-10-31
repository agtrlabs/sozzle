// Not required for test files
import 'package:level_generator/level_generator.dart';
import 'package:test/test.dart';

void main() {
  group('LevelGenerator', () {
    test('can be instantiated', () {
      final generator = LevelGenerator(
        crosswordGenerator: CrosswordGenerator(),
        wordListService: WordListService(wordListPath: 'Test String'),
        definitionFetcher: DefinitionFetcher(),
      );
      expect(generator, isNotNull);
    });
  });
}
