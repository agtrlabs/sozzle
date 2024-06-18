import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sozzle/src/audio/audio_controller.dart';
import 'package:sozzle/src/settings/cubit/setting_cubit.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockSettingsCubit settingsCubit;
  late AudioController audioController;
  setUp(() {
    settingsCubit = MockSettingsCubit();
    when(() => settingsCubit.state).thenReturn(SettingState.initial());
    audioController = AudioController(
      settingsCubit: settingsCubit,
      initialSettings: SettingState.initial(),
    );
  });

  test('audio controller ...', () {
    expect(audioController.settings, settingsCubit.state);
  });
}
