import 'package:flutter_test/flutter_test.dart';
import 'package:sozzle/src/game_play/domain/entities/booster.dart';

class MockBooster extends Booster {
  const MockBooster()
      : super(
          id: 'id',
          name: 'name',
          icon: 'icon',
          boosterCount: 10,
        );
}

void main() {
  late Booster booster;

  setUp(() {
    booster = const UseAHint(boosterCount: 10);
  });

  test('should be an IBooster', () {
    expect(booster, isA<IBooster>());
  });

  group('copyWith', () {
    test(
      'should return a [Booster] with the new [boosterCount]',
      () {
        final result = booster.copyWith(boosterCount: 100);
        expect(result, isA<Booster>());
        expect(result, isA<UseAHint>());
        expect(result.boosterCount, 100);
      },
    );

    test(
      'should return a [Booster] with the same [boosterCount] if '
      'no new [boosterCount] is provided',
      () {
        final result = booster.copyWith();
        expect(result, isA<Booster>());
        expect(result, isA<UseAHint>());
        expect(result.boosterCount, 10);
      },
    );

    test(
      'should return a [GenericBooster] when the type is not predefined',
      () {
        final result = const MockBooster().copyWith();
        expect(result, isA<Booster>());
        expect(result, isA<GenericBooster>());
        expect(result, isNot(isA<MockBooster>()));
      },
    );
  });

  group('increaseBy', () {
    test(
      'should return a [Booster] with the increased [boosterCount]',
      () {
        final result = booster.increaseBy(boosterCount: 100);

        expect(result, isA<Booster>());
        expect(result, isA<UseAHint>());
        expect(result.boosterCount, 110);
      },
    );
  });
}
