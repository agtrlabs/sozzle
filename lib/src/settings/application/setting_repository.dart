import 'package:localstore/localstore.dart';
import 'package:sozzle/src/settings/domain/i_setting_repository.dart';
import 'package:sozzle/src/settings/domain/settings.dart';

class SettingRepository implements ISettingRepository {
  final _db = Localstore.instance;

  @override
  Future<Settings> getSetting() async {
    return _getSettingData();
  }

  @override
  Future<bool> getSoundSetting() async {
    final settingData = await _getSettingData();
    return settingData.isSoundOn;
  }

  @override
  Future<void> setSoundSetting({required bool value}) async {
    final settingData = await _getSettingData();
    final newSettingData = settingData.copyWith(isSoundOn: value);
    print('set sound: ${newSettingData.toMap()}');

    await _db.collection(Settings.setting).doc(Settings.setting).set(
          newSettingData.toMap(),
        );
  }

  @override
  Future<bool> getMusicSetting() async {
    final settingData = await _getSettingData();
    return settingData.isMusicOn;
  }

  @override
  Future<void> setMusicSetting({required bool value}) async {
    final settingData = await _getSettingData();
    final newSettingData = settingData.copyWith(isMusicOn: value);
    print('set music: ${newSettingData.toMap()}');

    await _db.collection(Settings.setting).doc(Settings.setting).set(
          newSettingData.toMap(),
        );
  }

  @override
  Future<bool> getDarkModeSetting() async {
    final settingData = await _getSettingData();
    return settingData.isDarkMode;
  }

  @override
  Future<void> setDarkModeSetting({required bool value}) async {
    final settingData = await _getSettingData();
    final newSettingData = settingData.copyWith(isDarkMode: value);
    await _db.collection(Settings.setting).doc(Settings.setting).set(
          newSettingData.toMap(),
        );
  }

  @override
  Future<bool> getMuteSetting() async {
    final settingData = await _getSettingData();
    return settingData.isMute;
  }

  @override
  Future<void> setMuteSetting({required bool value}) async {
    final settingData = await _getSettingData();
    final newSettingData = settingData.copyWith(
      isMute: value,
    );
    print('set mute: ${newSettingData.toMap()}');

    await _db.collection(Settings.setting).doc(Settings.setting).set(
          newSettingData.toMap(),
        );
  }

  Future<Settings> _getSettingData() async {
    final data = await _db.collection(Settings.setting).get();
    final docSetting = data?[Settings.setting] as Map?;
    final setting = docSetting != null
        ? Settings.fromJson(
            Map<String, dynamic>.from(docSetting),
          )
        : Settings(
            isSoundOn: false,
            isMusicOn: false,
            isDarkMode: false,
            isMute: false,
          );
    return setting;
  }
}
