import 'package:equatable/equatable.dart';

class Settings extends Equatable {
  const Settings({
    required this.isSoundOn,
    required this.isMusicOn,
    required this.isDarkMode,
    required this.isMute,
    bool? isSoundOnCache,
    bool? isMusicOnCache,
  })  : isSoundOnCache = isSoundOnCache ?? isSoundOn,
        isMusicOnCache = isMusicOnCache ?? isMusicOn;

  const Settings.empty()
      : this(
          isSoundOn: false,
          isMusicOn: false,
          isDarkMode: true,
          isMute: true,
        );

  factory Settings.fromMap(Map<String, dynamic> map) => Settings(
        isSoundOn: map[sound] as bool? ?? false,
        isMusicOn: map[music] as bool? ?? false,
        isDarkMode: map[darkMode] as bool? ?? false,
        isMute: map[mute] as bool? ?? true,
        isMusicOnCache: map[cacheMusic] as bool? ?? false,
        isSoundOnCache: map[cacheSound] as bool? ?? false,
      );

  static const String sound = 'sound';
  static const String music = 'music';
  static const String darkMode = 'darkMode';
  static const String mute = 'mute';
  static const String setting = 'setting';
  static const String cacheMusic = 'isMusicOnCache';
  static const cacheSound = 'isSoundOnCache';

  final bool isSoundOn;
  final bool isMusicOn;
  final bool isDarkMode;
  final bool isMute;
  final bool isMusicOnCache;
  final bool isSoundOnCache;

  Map<String, dynamic> toMap() => {
        sound: isSoundOn,
        music: isMusicOn,
        darkMode: isDarkMode,
        mute: isMute,
        cacheMusic: isMusicOnCache,
        cacheSound: isSoundOnCache,
      };

  Settings copyWith({
    bool? isSoundOn,
    bool? isMusicOn,
    bool? isDarkMode,
    bool? isMute,
    bool? isMusicOnCache,
    bool? isSoundOnCache,
  }) {
    return Settings(
      isSoundOn: isSoundOn ?? this.isSoundOn,
      isMusicOn: isMusicOn ?? this.isMusicOn,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isMute: isMute ?? this.isMute,
      isSoundOnCache: isSoundOnCache ?? this.isSoundOnCache,
      isMusicOnCache: isMusicOnCache ?? this.isMusicOnCache,
    );
  }

  @override
  List<Object?> get props => [
        isSoundOn,
        isMusicOn,
        isDarkMode,
        isMute,
        isSoundOnCache,
        isMusicOnCache,
      ];
}
