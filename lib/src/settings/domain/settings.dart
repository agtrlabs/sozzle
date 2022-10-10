class Settings {
  Settings({
    required this.isSoundOn,
    required this.isMusicOn,
    required this.isDarkMode,
    required this.isMute,
  });

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
        isSoundOn: json[sound] as bool,
        isMusicOn: json[music] as bool,
        isDarkMode: json[darkMode] as bool,
        isMute: json[mute] as bool,
      );

  static const String sound = 'sound';
  static const String music = 'music';
  static const String darkMode = 'darkMode';
  static const String mute = 'mute';

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
}
