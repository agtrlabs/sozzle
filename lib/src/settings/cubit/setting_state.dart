part of 'setting_cubit.dart';

@immutable
class SettingState extends Equatable {
  const SettingState({
    required this.isDarkMode,
    required this.isMusicOn,
    required this.isMute,
    required this.isSoundOn,
  });

  factory SettingState.initial() => const SettingState(
        isDarkMode: false,
        isMusicOn: false,
        isMute: true,
        isSoundOn: false,
      );

  final bool isDarkMode;
  final bool isMusicOn;
  final bool isMute;
  final bool isSoundOn;

  SettingState copyWith({
    bool? isDarkMode,
    bool? isMusicOn,
    bool? isMute,
    bool? isSoundOn,
  }) =>
      SettingState(
        isDarkMode: isDarkMode ?? this.isDarkMode,
        isMusicOn: isMusicOn ?? this.isMusicOn,
        isMute: isMute ?? this.isMute,
        isSoundOn: isSoundOn ?? this.isSoundOn,
      );

  @override
  List<Object?> get props => [
        isDarkMode,
        isMusicOn,
        isMute,
        isSoundOn,
      ];
}
