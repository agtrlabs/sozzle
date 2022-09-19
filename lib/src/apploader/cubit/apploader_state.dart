part of 'apploader_cubit.dart';

abstract class ApploaderState {
  const ApploaderState();
}

/// initial state to show Splash Screen
class ApploaderStateInitial extends ApploaderState {
  const ApploaderStateInitial();
}

/// loading updated game data from server
class ApploaderStateLoadingPuzzles extends ApploaderState {
  const ApploaderStateLoadingPuzzles(this.percent);
  final int percent;
}

/// loading user data from server
class ApploaderStateLoadingUserData extends ApploaderState {
  const ApploaderStateLoadingUserData(this.percent);
  final int percent;
}

/// All data loaded and the app is ready
class ApploaderStateLoaded extends ApploaderState {
  const ApploaderStateLoaded();
}
