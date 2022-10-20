import 'package:equatable/equatable.dart';

abstract class Reward extends Equatable {
  const Reward();
  String get name;
  String get description;
  String get image;
  int get points;
  int get id;

  @override
  List<Object?> get props => [name, description, image, points, id];
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

  const Badge({
    required this.name,
    required this.description,
    required this.image,
    required this.points,
    required this.id,
  });
}
