import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:sozzle/src/settings/domain/settings.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  const settings = Settings.empty();

  final json = fixture('settings.json');
  final map = jsonDecode(json) as Map<String, dynamic>;

  group('fromMap', () {
    test(
      'should return a [Settings] object with the correct values',
      () {
        final result = Settings.fromMap(map);

        expect(result, equals(settings));
      },
    );
  });

  group('toMap', () {
    test(
      'should return a [Map] with the appropriate data',
      () {
        final result = settings.toMap();
        expect(result, equals(map));
      },
    );
  });

  group('copyWith', () {
    test('should return [Settings] with the new data', () {
      final result = settings.copyWith(isDarkMode: false);

      expect(result.isDarkMode, false);
      expect(result, isNot(settings));
    });
  });
}
