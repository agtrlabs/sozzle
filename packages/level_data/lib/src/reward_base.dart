import 'dart:convert';

import 'package:equatable/equatable.dart';

/// A base model representing a reward
abstract class Reward extends Equatable {
  /// Creates a [Reward] instance
  const Reward();

  /// Creates a [Reward] instance from a JSON string
  factory Reward.fromJson(String source) =>
      Reward.fromMap(json.decode(source) as Map<String, dynamic>);

  /// Creates a [Reward] instance from a map
  factory Reward.fromMap(Map<String, dynamic> json) {
    switch (json['type'] as String) {
      case 'coin':
        return RewardCoin.fromMap(json);
      case 'badge':
        return Badge.fromMap(json);
      default:
        throw Exception('Unknown reward type');
    }
  }

  /// The name of the reward
  String get name;

  /// The type of the reward
  String get type;

  /// The description of the reward
  String get description;

  /// The image of the reward
  String get image;

  /// The points of the reward
  int get points;

  /// The id of the reward
  int get id;

  @override
  List<Object?> get props => [name, description, image, points, id];

  /// Converts the [Reward] instance to a map
  Map<String, dynamic> toMap();

  /// Converts the [Reward] instance to a JSON string
  String toJson() => json.encode(toMap());
}

/// A model representing a coin reward
class RewardCoin extends Reward {
  /// Creates a [RewardCoin] instance
  const RewardCoin({
    required this.name,
    required this.description,
    required this.image,
    required this.points,
    required this.id,
  });

  /// Creates a [RewardCoin] instance from a map
  factory RewardCoin.fromMap(Map<String, dynamic> map) {
    return RewardCoin(
      name: map['name'] as String,
      description: map['description'] as String,
      image: map['image'] as String,
      points: map['points'] as int,
      id: map['id'] as int,
    );
  }

  @override
  final String name;
  @override
  final String description;
  @override
  final String image;
  @override
  final int points;
  @override
  final int id;

  @override
  String get type => 'coin';

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'image': image,
      'points': points,
      'id': id,
      'type': type,
    };
  }
}

/// A model representing a badge reward
class Badge extends Reward {
  /// Creates a [Badge] instance
  const Badge({
    required this.name,
    required this.description,
    required this.image,
    required this.points,
    required this.id,
  });

  /// Creates a [Badge] instance from a map
  factory Badge.fromMap(Map<String, dynamic> map) {
    return Badge(
      name: map['name'] as String,
      description: map['description'] as String,
      image: map['image'] as String,
      points: map['points'] as int,
      id: map['id'] as int,
    );
  }

  @override
  final String name;
  @override
  final String description;
  @override
  final String image;
  @override
  final int points;
  @override
  final int id;

  @override
  String get type => 'badge';

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'image': image,
      'points': points,
      'id': id,
      'type': type,
    };
  }
}
