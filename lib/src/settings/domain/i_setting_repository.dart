import 'package:sozzle/src/settings/domain/settings.dart';

abstract class ISettingRepository {
  Future<Settings> getSetting();

//   Future<bool> getSoundSetting();
  Future<void> setSoundSetting({required bool value});

//   Future<bool> getMusicSetting();
  Future<void> setMusicSetting({required bool value});

  Future<bool> getDarkModeSetting();
  Future<void> setDarkModeSetting({required bool value});

//   Future<bool> getMuteSetting();
  Future<void> setMuteSetting({required bool value});
}
