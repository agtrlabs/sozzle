import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sozzle/l10n/l10n.dart';

import 'package:sozzle/src/settings/cubit/setting_cubit.dart';

import 'package:sozzle/src/theme/cubit/theme_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const path = 'settings';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<SettingCubit, SettingState>(
          builder: (context, state) {
            if (state is SettingInitial) {
              return Scaffold(
                body: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        themeState.backgroundColor,
                        themeState.backgroundColor.withOpacity(0.9),
                        themeState.backgroundColor.withOpacity(0.8),
                        themeState.backgroundColor.withOpacity(0.7),
                        themeState.backgroundColor.withOpacity(0.4),
                        themeState.backgroundColor.withOpacity(0.1),
                      ],
                    ),
                  ),
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: ListView(
                        children: <Widget>[
                          const SizedBox(
                            height: 50,
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.music_note,
                              color: Colors.white,
                              size: 40,
                            ),
                            minLeadingWidth: 0,
                            title: Text(
                              context.l10n.soundSettings,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                              ),
                            ),
                            trailing: Switch.adaptive(
                              key: const Key('switchSound'),
                              value: state.isSoundOn,
                              onChanged: (val) {
                                final settingCubit = context
                                    .read<SettingCubit>()
                                  ..toggleSoundOption(val: val);
                                if (val && state.isMute) {
                                  settingCubit.toggleMuteOption(val: !val);
                                }
                                if (!val && !state.isMusicOn) {
                                  settingCubit.toggleMuteOption(val: !val);
                                }
                              },
                            ),
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.volume_down,
                              color: Colors.white,
                              size: 40,
                            ),
                            minLeadingWidth: 0,
                            title: Text(
                              context.l10n.musicSettings,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                              ),
                            ),
                            trailing: Switch.adaptive(
                              value: state.isMusicOn,
                              onChanged: (val) {
                                final settingCubit = context
                                    .read<SettingCubit>()
                                  ..toggleMusicOption(val: val);
                                if (state.isMute && val) {
                                  settingCubit.toggleMuteOption(val: !val);
                                }
                                if (!val && !state.isSoundOn) {
                                  settingCubit.toggleMuteOption(val: !val);
                                }
                              },
                            ),
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.dark_mode,
                              color: Colors.white,
                              size: 40,
                            ),
                            minLeadingWidth: 0,
                            title: Text(
                              context.l10n.darkModeSettings,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                              ),
                            ),
                            trailing: Switch.adaptive(
                              value: state.isDarkMode,
                              onChanged: (val) => context
                                  .read<SettingCubit>()
                                  .toggleDarkModeOption(val: val),
                            ),
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.music_off,
                              color: Colors.white,
                              size: 40,
                            ),
                            minLeadingWidth: 0,
                            title: Text(
                              context.l10n.muteSettings,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                              ),
                            ),
                            trailing: Switch.adaptive(
                              value: state.isMute,
                              onChanged: (val) {
                                final settingCubit = context
                                    .read<SettingCubit>()
                                  ..toggleMuteOption(val: val);
                                if (state.isMusicOn == val) {
                                  settingCubit.toggleMusicOption(val: !val);
                                }
                                if (state.isSoundOn == val) {
                                  settingCubit.toggleSoundOption(val: !val);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
            return Container();
          },
        );
      },
    );
  }
}
