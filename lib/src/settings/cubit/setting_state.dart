part of 'setting_cubit.dart';

@immutable
abstract class SettingState extends Equatable {}

class SettingInitial extends SettingState {
  SettingInitial({
    required this.isSoundOn,
    required this.isMusicOn,
    required this.isDarkMode,
    required this.isMute,
  });

  final bool isSoundOn;
  final bool isMusicOn;
  final bool isDarkMode;
  final bool isMute;

  SettingInitial copyWith({
    bool? isSoundOn,
    bool? isMusicOn,
    bool? isDarkMode,
    bool? isMute,
  }) {
    return SettingInitial(
      isSoundOn: isSoundOn ?? this.isSoundOn,
      isMusicOn: isMusicOn ?? this.isMusicOn,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isMute: isMute ?? this.isMute,
    );
  }

  @override
  List<Object?> get props => [
        isSoundOn,
        isMusicOn,
        isDarkMode,
        isMute,
      ];
}
