import 'package:equatable/equatable.dart';

abstract class Reward extends Equatable {
  const Reward();
  String get name;
  String get type;
  String get description;
  String get image;
  int get points;
  int get id;

  @override
  List<Object?> get props => [name, description, image, points, id];

  Map<String, dynamic> toMap();

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
}

class RewardCoin extends Reward {
  const RewardCoin({
    required this.name,
    required this.description,
    required this.image,
    required this.points,
    required this.id,
  });

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

  factory RewardCoin.fromMap(Map<String, dynamic> map) {
    return RewardCoin(
      name: map['name'] as String,
      description: map['description'] as String,
      image: map['image'] as String,
      points: map['points'] as int,
      id: map['id'] as int,
    );
  }
}

class Badge extends Reward {
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

  const Badge({
    required this.name,
    required this.description,
    required this.image,
    required this.points,
    required this.id,
  });

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

  factory Badge.fromMap(Map<String, dynamic> map) {
    return Badge(
      name: map['name'] as String,
      description: map['description'] as String,
      image: map['image'] as String,
      points: map['points'] as int,
      id: map['id'] as int,
    );
  }
}
