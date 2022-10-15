// import 'package:bloc_test/bloc_test.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:sozzle/src/settings/application/setting_repository.dart';
// import 'package:sozzle/src/settings/cubit/setting_cubit.dart';
// import 'package:sozzle/src/settings/domain/i_setting_repository.dart';
// import 'package:sozzle/src/theme/cubit/theme_cubit.dart';

// class MockSettingsRepo extends Mock implements ISettingRepository {}

// class MockThemeCubit extends Mock implements ThemeCubit {}

// class MockSettingCubit extends Mock implements SettingCubit {}

// void main() {
//   group(
//     'Setting Cubit',
//     () {
//       blocTest<SettingCubit, SettingState>(
//         '',
//         setUp: () {
//           WidgetsFlutterBinding.ensureInitialized();
//         },
//         build: () => SettingCubit(
//           settingRep: SettingRepository(),
//           themeCubit: ThemeCubit(
//             isDarkMode: Future.value(false),
//           ),
//         ),
//         act: (bloc) => bloc.toggleDarkModeOption(val: true),
//         expect: () => [
//           SettingInitial(
//             isSoundOn: false,
//             isMusicOn: false,
//             isDarkMode: true,
//             isMute: false,
//           ),
//         ],
//       );

//       blocTest<SettingCubit, SettingState>(
//         '',
//         setUp: () {},
//         build: () => SettingCubit(
//           settingRep: SettingRepository(),
//           themeCubit: ThemeCubit(
//             isDarkMode: Future.value(false),
//           ),
//         ),
//         act: (bloc) => bloc
//           ..toggleMuteOption(val: true)
//           ..toggleMusicOption(
//             val: true,
//           )
//           ..toggleSoundOption(val: true)
//           ..toggleDarkModeOption(val: true)
//           ..toggleMuteOption(val: false),
//         expect: () => [
//           SettingInitial(
//             isSoundOn: false,
//             isMusicOn: false,
//             isDarkMode: false,
//             isMute: true,
//           ),
//           SettingInitial(
//             isSoundOn: false,
//             isMusicOn: true,
//             isDarkMode: false,
//             isMute: true,
//           ),
//           SettingInitial(
//             isSoundOn: true,
//             isMusicOn: true,
//             isDarkMode: false,
//             isMute: true,
//           ),
//           SettingInitial(
//             isSoundOn: true,
//             isMusicOn: true,
//             isDarkMode: true,
//             isMute: true,
//           ),
//           SettingInitial(
//             isSoundOn: true,
//             isMusicOn: true,
//             isDarkMode: true,
//             isMute: false,
//           ),
//         ],
//       );
//     },
//   );
// }
