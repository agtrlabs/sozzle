import 'package:equatable/equatable.dart';

class Settings extends Equatable {
  const Settings({
    required this.isSoundOn,
    required this.isMusicOn,
    required this.isDarkMode,
    required this.isMute,
  });

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
        isSoundOn: json[sound] as bool? ?? false,
        isMusicOn: json[music] as bool? ?? false,
        isDarkMode: json[darkMode] as bool? ?? false,
        isMute: json[mute] as bool? ?? false,
      );

  static const String sound = 'sound';
  static const String music = 'music';
  static const String darkMode = 'darkMode';
  static const String mute = 'mute';
  static const String setting = 'setting';

  final bool isSoundOn;
  final bool isMusicOn;
  final bool isDarkMode;
  final bool isMute;

  Map<String, dynamic> toMap() => {
        sound: isSoundOn,
        music: isMusicOn,
        darkMode: isDarkMode,
        mute: isMute,
      };

  Settings copyWith({
    bool? isSoundOn,
    bool? isMusicOn,
    bool? isDarkMode,
    bool? isMute,
  }) {
    return Settings(
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
