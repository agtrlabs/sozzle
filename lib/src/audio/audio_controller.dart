// coverage:ignore-file
import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:sozzle/src/audio/domain/i_audio_controller.dart';
import 'package:sozzle/src/audio/domain/sfx.dart';
import 'package:sozzle/src/settings/cubit/setting_cubit.dart';

/// plays audio
/// checks settings for mute and audio levels
class AudioController implements IAudioController {
  AudioController({
    required SettingCubit settingsCubit,
    required SettingState initialSettings,
  }) {
    preloadSfx();
    _settings = initialSettings;
    settingsCubit.stream.listen(_reloadSettings);
  }

  late SettingState _settings;
  Map<Sfx, AudioPlayer> players = {};

  @override
  SettingState get settings => _settings;

  @override
  Future<void> play(Sfx sfx) async {
    if (!_settings.isMute && _settings.isSoundOn) {
      //await player.play(AssetSource(sound[sfx]!));

      await players[sfx]!.play(AssetSource(sound[sfx]!));
    }
  }

  void _reloadSettings(SettingState settings) {
    _settings = settings;
    return;
  }

  Future<void> preloadSfx() async {
    for (final sfx in Sfx.values) {
      players[sfx] = AudioPlayer();
    }
    players.forEach((key, value) async {
      await players[key]!.setSource(AssetSource(sound[key]!));
      await players[key]!.setPlayerMode(PlayerMode.lowLatency);
    });
  }
}
