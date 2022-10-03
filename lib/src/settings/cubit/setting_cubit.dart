import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'setting_state.dart';

class SettingCubit extends Cubit<SettingState> {
  SettingCubit()
      : super(
          SettingInitial(
            isSoundOn: false,
            isMusicOn: false,
            isMute: false,
            isDarkMode: false,
          ),
        );

  void toggleSoundOption() {
    final state = this.state;
    late final SettingInitial newState;
    if (state is SettingInitial) {
      newState = state.copyWith(isSoundOn: !state.isSoundOn);
      emit(newState);
    }
  }

  void toggleMusicOption() {
    final state = this.state;
    late final SettingInitial newState;
    if (state is SettingInitial) {
      newState = state.copyWith(isMusicOn: !state.isMusicOn);
      emit(newState);
    }
  }

  void toggleDarkModeOption() {
    final state = this.state;
    late final SettingInitial newState;
    if (state is SettingInitial) {
      newState = state.copyWith(isDarkMode: !state.isDarkMode);
      emit(newState);
    }
  }

  void toggleMuteOption() {
    final state = this.state;
    late final SettingInitial newState;
    if (state is SettingInitial) {
      newState = state.copyWith(isMute: !state.isMute);
      emit(newState);
    }
  }
}
