import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'setting_state.dart';

class SettingCubit extends Cubit<SettingState> {
  SettingCubit() : super(SettingState.initial());

  void toggleSoundOption({required bool val}) {
    emit(state.copyWith(isSoundOn: val));
  }

  void toggleMusicOption({required bool val}) {
    emit(state.copyWith(isMusicOn: val));
  }

  void toggleDarkModeOption({required bool val}) {
    emit(state.copyWith(isDarkMode: val));
  }

  void toggleMuteOption({required bool val}) {
    emit(state.copyWith(isMute: val));
  }
}
