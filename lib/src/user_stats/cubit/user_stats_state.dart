part of 'user_stats_cubit.dart';

class UserStatsState extends Equatable {
  const UserStatsState({required this.progress});

  factory UserStatsState.initial() =>
      UserStatsState(progress: UserProgressData(currentLevel: 1));

  final UserProgressData progress;
  @override
  List<Object> get props => [progress];
}
