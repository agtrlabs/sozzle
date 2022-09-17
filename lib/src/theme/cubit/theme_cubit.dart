import 'package:bloc/bloc.dart';
import 'package:flutter/painting.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeStateDark());
}
