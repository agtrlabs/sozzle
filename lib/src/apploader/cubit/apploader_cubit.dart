import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sozzle/src/apploader/apploader.dart';

part 'apploader_state.dart';

/// Loads Updates the game data and user data
/// Saves to local
class ApploaderCubit extends Cubit<ApploaderState> {
  ApploaderCubit({required this.apploaderRepository})
      : super(const ApploaderState(LoaderState.initial));

  IApploaderRepository apploaderRepository;

  Future<void> updatePuzzleData() async {
    //start loading data
    emit(const ApploaderState(LoaderState.loadingPuzzle));

    await apploaderRepository.getLevels();

    // update status while loading

    final saveData = apploaderRepository.saveData();

    await for (final percent in saveData) {
      emit(
        ApploaderState(LoaderState.loadingPuzzle, percent),
      );
    }

    // be sure to finalize loading by emitting 100 percent
    emit(const ApploaderState(LoaderState.loadingPuzzle, 1));
  }

  Future<void> updateUserData() async {
    //start loading user data
    emit(const ApploaderState(LoaderState.loadingUserData, 0));

    //final userData = await apploaderRepository.getUserProgressData();

    final saveData = apploaderRepository.saveData();

    await for (final percent in saveData) {
      emit(
        ApploaderState(
          LoaderState.loadingUserData,
          percent,
        ),
      );
    }
    emit(const ApploaderState(LoaderState.loadingUserData, 100));

    setAppReady();
  }

  void setAppReady() {
    emit(const ApploaderState(LoaderState.loaded, 100));
  }
}
