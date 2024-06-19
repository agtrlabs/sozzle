import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:sozzle/src/game_play/domain/entities/booster.dart';
import 'package:sozzle/src/user_stats/domain/i_user_stats_repository.dart';
import 'package:sozzle/src/user_stats/domain/user_progress_data.dart';

part 'user_stats_state.dart';

class UserStatsCubit extends Cubit<UserStatsState> {
  UserStatsCubit(this.repository) : super(UserStatsState.initial());

  IUserStatsRepository repository;

  void readCurrentStats() {
    repository
        .getCurrent()
        .then((value) => emit(UserStatsState(progress: value)));
  }

  void advanceLevelUp() {
    final newProgress = state.progress.copyWith(
      currentLevel: state.progress.currentLevel + 1,
      // TODO(Level-up): Change the points later
      points: state.progress.points + 10,
    );
    emit(UserStatsState(progress: newProgress));
    repository.save(newProgress);
  }

  void useAHint() {
    final boosters = state.progress.boosters;
    final hasHint = boosters.any(
      (booster) => booster is UseAHint && booster.boosterCount > 0,
    );
    if (!hasHint) return;

    final hintBoosterIndex = boosters.indexWhere(
      (booster) => booster is UseAHint && booster.boosterCount > 0,
    );

    final hintBooster = boosters[hintBoosterIndex] as UseAHint;

    final newBoosters = List<Booster>.from(boosters);
    newBoosters[hintBoosterIndex] = hintBooster.decreaseBy(boosterCount: 1);

    if (hintBoosterIndex == -1) return;
    final newProgress = state.progress.copyWith(
      boosters: newBoosters,
    );

    debugPrint('Old Hint count: ${boosters[hintBoosterIndex].boosterCount}');
    debugPrint(
      'New Hint count: ${newProgress.boosters[hintBoosterIndex].boosterCount}',
    );

    emit(UserStatsState(progress: newProgress));
    repository.save(state.progress);
  }
}
