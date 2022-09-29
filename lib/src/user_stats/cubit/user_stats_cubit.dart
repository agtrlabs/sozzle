import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sozzle/src/user_stats/domain/i_user_stats_repository.dart';
import 'package:sozzle/src/user_stats/domain/user_progress_data.dart';

part 'user_stats_state.dart';

class UserStatsCubit extends Cubit<UserStatsState> {
  UserStatsCubit(this.repository) : super(UserStatsState.initial());

  IUserStatsRepository repository;

  void advanceLevelUp() {
    final newProgress = UserProgressData(
      currentLevel: state.progress.currentLevel + 1,
    );
    emit(UserStatsState(progress: newProgress));
    repository.save(newProgress);
  }
}
