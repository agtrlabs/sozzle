part of 'setting_cubit.dart';

@immutable
class SettingState extends Equatable {
  const SettingState({
    required this.isSoundOn,
    required this.isMusicOn,
    required this.isDarkMode,
    required this.isMute,
  });

  factory SettingState.initial() => const SettingState(
        isSoundOn: false,
        isMusicOn: false,
        isDarkMode: false,
        isMute: true,
      );

  final bool isSoundOn;
  final bool isMusicOn;
  final bool isDarkMode;
  final bool isMute;

  SettingState copyWith({
    bool? isSoundOn,
    bool? isMusicOn,
    bool? isDarkMode,
    bool? isMute,
  }) =>
      SettingState(
        isSoundOn: isSoundOn ?? this.isSoundOn,
        isMusicOn: isMusicOn ?? this.isMusicOn,
        isDarkMode: isDarkMode ?? this.isDarkMode,
        isMute: isMute ?? this.isMute,
      );

  @override
  List<Object?> get props => [
        isSoundOn,
        isMusicOn,
        isDarkMode,
        isMute,
      ];
}
