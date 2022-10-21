import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final List<dynamic> properties;
  const Failure([this.properties = const <dynamic>[]]);

  @override
  List<dynamic> get props => properties;
}
