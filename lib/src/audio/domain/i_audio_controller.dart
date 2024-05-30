// coverage:ignore-file
import 'package:sozzle/src/audio/domain/sfx.dart';
import 'package:sozzle/src/settings/cubit/setting_cubit.dart';

abstract class IAudioController {
  IAudioController({required this.settings});

  final SettingState settings;

  void play(Sfx sfx);
}
