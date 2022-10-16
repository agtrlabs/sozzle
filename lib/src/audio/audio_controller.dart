import 'package:audioplayers/audioplayers.dart';
import 'package:sozzle/src/audio/domain/i_audio_controller.dart';
import 'package:sozzle/src/audio/domain/sfx.dart';
import 'package:sozzle/src/settings/cubit/setting_cubit.dart';

class AudioController implements IAudioController {
  AudioController({required SettingState settings}) : _settings = settings;

  late final SettingState _settings;
  final player = AudioPlayer();

  @override
  SettingState get settings => _settings;

  @override
  void play(Sfx sfx) async {
    // if (!_settings.isMute && _settings.isSoundOn) {
    await player.play(AssetSource(sound[sfx]!));

    // }
  }
}
