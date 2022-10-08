import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:sozzle/src/theme/domain/themes.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeStateDark());

  void getThemeDark() {
    emit(ThemeStateDark());
  }

  void getThemeLight() {
    emit(ThemeStateLight());
  }
}
