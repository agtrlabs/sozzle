import 'package:level_generator/src/app/crossword_generator.dart';
import 'package:test/test.dart';

void main() {
  late CrosswordGenerator generator;
  late CrosswordGrid? grid;

  setUpAll(() {
    generator = const CrosswordGenerator(shuffle: false);
    final tWords = [
      'RIFLE',
      'FLIRT',
      'FIRE',
      'LEFT',
      'TIRE',
      'REFIT',
      'FILTER',
      'RELIT',
      'TIER',
    ];
    grid = generator.generate(tWords);
  });

  final tFirstViableBoardData = [
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
    '',
    '',
    'E',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    'F',
    '',
    '',
    '',
    '',
    '',
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
    '',
    '',
    '',
    'F',
    'I',
    'L',
    'T',
    'E',
    'R',
    '',
    '',
    '',
    '',
    '',
    '',
    'L',
    '',
    'E',
    '',
    '',
    'I',
    '',
    '',
    '',
    '',
    '',
    '',
    'I',
    '',
    'F',
    '',
    '',
    'F',
    'I',
    'R',
    'E',
    'T',
    'I',
    'E',
    'R',
    '',
    'T',
    '',
    '',
    'L',
    '',
    '',
    '',
    '',
    '',
    '',
    'T',
    '',
    '',
    '',
    'R',
    'E',
    'L',
    'I',
    'T',
  ];

  test('should return the first viable board grid', () {
    expect(grid!.flattenedBoardData, equals(tFirstViableBoardData));
    expect(grid!.flattenedBoardData.length, equals(108));
    expect(grid!.width, equals(12));
    expect(grid!.height, equals(9));
  });

  test('should return null if no board can be generated', () {
    final result = generator.generate(['A', 'B', 'C']);

    expect(result, isNull);
  });
}
