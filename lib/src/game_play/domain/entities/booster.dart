import 'package:equatable/equatable.dart';
import 'package:sozzle/core/res/media.dart';

abstract class IBooster extends Equatable {
  const IBooster();

  /// Unique identifier for the booster
  String get id;

  /// Name of the booster
  String get name;

  /// Icon of the booster
  String get icon;

  /// Number of this booster the user has
  int get boosterCount;

  /// Create a new instance of the booster with the new [boosterCount]
  IBooster copyWith({int? boosterCount});

  /// Increase the [boosterCount] by the given [boosterCount]
  IBooster increaseBy({int? boosterCount});

  /// Decrease the [boosterCount] by the given [boosterCount]
  IBooster decreaseBy({int? boosterCount});

  @override
  List<Object> get props => [id];
}

class Booster extends IBooster {
  const Booster({
    required this.id,
    required this.name,
    required this.icon,
    required this.boosterCount,
  });

  factory Booster.fromId({required String id, required int boosterCount}) {
    return switch (id) {
      UseAHint.boosterId => UseAHint(boosterCount: boosterCount),
      _ => Booster(
          id: id,
          name: 'Booster',
          icon: 'Icon',
          boosterCount: boosterCount,
        ),
    };
  }

  @override
  final String id;
  @override
  final String name;
  @override
  final String icon;
  @override
  final int boosterCount;

  @override
  Booster copyWith({int? boosterCount}) {
    if (runtimeType == UseAHint) {
      return UseAHint(boosterCount: boosterCount ?? this.boosterCount);
    }
    return const GenericBooster();
  }

  @override
  Booster increaseBy({int? boosterCount}) {
    return copyWith(boosterCount: this.boosterCount + boosterCount!);
  }

  @override
  Booster decreaseBy({int? boosterCount}) {
    return copyWith(boosterCount: this.boosterCount - boosterCount!);
  }
}

/// A generic booster that does nothing.
/// <br />
/// Please <span style="color: red;">DO NOT</span> use this in production.
class GenericBooster extends Booster {
  const GenericBooster()
      : super(
          id: 'generic',
          name: 'Generic Booster',
          icon: '#well',
          boosterCount: 0,
        );
}

/// A booster that reveals a random letter in the puzzle.
class UseAHint extends Booster {
  /// A booster that reveals a random letter in the puzzle.
  const UseAHint({required super.boosterCount})
      : super(
          id: boosterId,
          name: 'Reveal a Random Letter',
          icon: Media.hint,
        );

  static const boosterId = 'revealARandomLetter';
}
