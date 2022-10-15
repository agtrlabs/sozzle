import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sozzle/src/settings/domain/i_setting_repository.dart';
import 'package:sozzle/src/theme/cubit/theme_cubit.dart';
import 'package:sozzle/utilities/settings_helper.dart';

part 'setting_state.dart';

class SettingCubit extends Cubit<SettingState> {
  // SettingCubit(this.context)
  SettingCubit({
    required this.settingRep,
    required this.themeCubit,
  }) : super(
          SettingInitial(
            isSoundOn: false,
            isMusicOn: false,
            isMute: false,
            isDarkMode: false,
          ),
        );
  final ISettingRepository settingRep;
  final ThemeCubit themeCubit;

  Future<void> initialize() async {
    final state = this.state;
    if (state is SettingInitial) {
      final setting = await settingRep.getSetting();
      final newSettingState = state.copyWith(
        isSoundOn: setting.isSoundOn,
        isMusicOn: setting.isMusicOn,
        isDarkMode: setting.isDarkMode,
        isMute: setting.isMute,
      );
      emit(newSettingState);
    }
  }

  Future<void> toggleSoundOption({required bool val}) async {
    final state = this.state;
    late final SettingInitial newState;
    if (state is SettingInitial) {
      newState = state.copyWith(
        isSoundOn: val,
        isMute: SettingsHelper.turnOffMuteMaybe(val: val),
      );
      await settingRep.setSoundSetting(value: val);
      await settingRep.setMuteSetting(value: newState.isMute);
      emit(newState);
    }
  }

  Future<void> toggleMusicOption({required bool val}) async {
    final state = this.state;
    late final SettingInitial newState;
    if (state is SettingInitial) {
      newState = state.copyWith(
        isMusicOn: val,
        isMute: SettingsHelper.turnOffMuteMaybe(val: val),
      );
      await settingRep.setMusicSetting(value: val);
      await settingRep.setMuteSetting(
        value: newState.isMute,
      );
      emit(newState);
    }
  }

  Future<void> toggleDarkModeOption({required bool val}) async {
    final state = this.state;
    late final SettingInitial newState;
    if (state is SettingInitial) {
      newState = state.copyWith(isDarkMode: val);
      await settingRep.setDarkModeSetting(value: val);

      if (newState.isDarkMode) {
        await themeCubit.getThemeDark();
      } else {
        await themeCubit.getThemeLight();
      }
      emit(newState);
    }
  }

  Future<void> toggleMuteOption({required bool val}) async {
    final state = this.state;
    late final SettingInitial newState;
    if (state is SettingInitial) {
      newState = state.copyWith(
        isMute: val,
        isMusicOn: SettingsHelper.turnOffSoundAndMusicMaybe(val: val),
        isSoundOn: SettingsHelper.turnOffSoundAndMusicMaybe(val: val),
      );
      await settingRep.setMuteSetting(value: val);
      await settingRep.setMusicSetting(
        value: newState.isMusicOn,
      );
      await settingRep.setSoundSetting(
        value: newState.isSoundOn,
      );

      emit(newState);
    }
  }
}
