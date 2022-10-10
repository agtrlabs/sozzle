import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sozzle/src/theme/cubit/theme_cubit.dart';

part 'setting_state.dart';

class SettingCubit extends Cubit<SettingState> {
  // SettingCubit(this.context)
  SettingCubit(this.themeCubit)
      : super(
          SettingInitial(
            isSoundOn: false,
            isMusicOn: false,
            isMute: false,
            isDarkMode: false,
          ),
        );
  // final BuildContext context;
  final ThemeCubit themeCubit;

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
      // final themeCubit = BlocProvider.of<ThemeCubit>(context);
      if (newState.isDarkMode) {
        themeCubit.getThemeDark();
      } else {
        themeCubit.getThemeLight();
      }
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
