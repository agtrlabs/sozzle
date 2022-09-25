import 'dart:async';

import 'package:bloc/bloc.dart';

part 'apploader_state.dart';

// TODO(akyunus): Implement data loading
class ApploaderCubit extends Cubit<ApploaderState> {
  ApploaderCubit() : super(const ApploaderState(LoaderState.initial, 0));

  Future<void> updatePuzzleData() async {
    //start loading data
    emit(const ApploaderState(LoaderState.loadingPuzzle, 0));

    // update status while loading

    await Future.delayed(const Duration(milliseconds: 500), () {});
    // be sure to finalize loading by emitting 100 percent
    emit(const ApploaderState(LoaderState.loadingPuzzle, 100));
    unawaited(updateUserData());
  }

  Future<void> updateUserData() async {
    //start loading user data
    emit(const ApploaderState(LoaderState.loadingUserData, 0));

    // TODO(akyunus): implement logic to load  user data
    await Future.delayed(const Duration(milliseconds: 500), () {});
    setAppReady();
  }

  void setAppReady() {
    emit(const ApploaderState(LoaderState.loaded, 100));
  }
}
