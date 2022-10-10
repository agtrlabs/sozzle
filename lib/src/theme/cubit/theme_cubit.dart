import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeStateLight());

  void getThemeDark() {
    emit(const ThemeStateDark());
  }

  void getThemeLight() {
    emit(const ThemeStateLight());
  }
}
