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

  void toggleSoundOption({required bool val}) {
    final state = this.state;
    late final SettingInitial newState;
    if (state is SettingInitial) {
      newState = state.copyWith(isSoundOn: val);
      emit(newState);
    }
  }

  void toggleMusicOption({required bool val}) {
    final state = this.state;
    late final SettingInitial newState;
    if (state is SettingInitial) {
      newState = state.copyWith(isMusicOn: val);
      emit(newState);
    }
  }

  void toggleDarkModeOption({required bool val}) {
    final state = this.state;
    late final SettingInitial newState;
    if (state is SettingInitial) {
      newState = state.copyWith(isDarkMode: val);
      emit(newState);
    }
  }

  void toggleMuteOption({required bool val}) {
    final state = this.state;
    late final SettingInitial newState;
    if (state is SettingInitial) {
      newState = state.copyWith(isMute: val);
      emit(newState);
    }
  }
}
