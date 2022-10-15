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
    // start loading setting data
    await updateSettingsData();

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

    await updateUserData();
    // await updateSettingsData();
  }

  Future<void> updateSettingsData() async {
    emit(const ApploaderState(LoaderState.loadingSettingsData));

    await apploaderRepository.getSetting();

    // Add pseudo delay for loading indicator.
    await for (final x in Stream.fromIterable([1, 2, 3, 4, 5])) {
      await Future<void>.delayed(const Duration(milliseconds: 200));
      emit(
        ApploaderState(
          LoaderState.loadingSettingsData,
          (100 / 5) * x,
        ),
      );
    }
    emit(
      const ApploaderState(LoaderState.loadingSettingsData, 100),
    );
  }

  Future<void> updateUserData() async {
    //start loading user data
    emit(const ApploaderState(LoaderState.loadingUserData));

    await apploaderRepository.getUserProgressData();

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
