part of 'apploader_cubit.dart';

/// initial state to show Splash Screen
/// loading updated game data from server
/// loading user data from server
/// loaded: All data loaded and the app is ready
enum LoaderState {
  initial,
  loadingPuzzle,
  loadingUserData,
  loadingSettingsData,
  loaded
}

class ApploaderState extends Equatable {
  const ApploaderState(this.loaderState, [this.percent = 0]);
  final double percent;
  final LoaderState loaderState;

  @override
  List<Object?> get props => [loaderState, percent];
}
