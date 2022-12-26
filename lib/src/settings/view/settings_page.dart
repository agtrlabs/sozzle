import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sozzle/l10n/l10n.dart';
import 'package:sozzle/src/home/home.dart';

import 'package:sozzle/src/settings/cubit/setting_cubit.dart';

import 'package:sozzle/src/theme/cubit/theme_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const path = '/settings';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<SettingCubit, SettingState>(
          builder: (context, state) {
            return Scaffold(
              body: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      themeState.backgroundColor.withOpacity(0.9),
                      themeState.backgroundColor.withOpacity(0.8),
                      themeState.backgroundColor.withOpacity(0.7),
                      themeState.backgroundColor.withOpacity(0.4),
                      themeState.backgroundColor.withOpacity(0.1),
                    ],
                  ),
                ),
                child: Center(
                  child: SafeArea(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios_new,
                              color: themeState.primaryTextColor,
                            ),
                            onPressed: () {
                              context.go(HomePage.path);
                            },
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: ListView(
                            shrinkWrap: true,
                            children: <Widget>[
                              const SizedBox(
                                height: 25,
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.music_note,
                                  color: themeState.primaryTextColor,
                                  size: 40,
                                ),
                                minLeadingWidth: 0,
                                title: Text(
                                  context.l10n.soundSettings,
                                  style: TextStyle(
                                    color: themeState.primaryTextColor,
                                    fontSize: 22,
                                  ),
                                ),
                                trailing: Switch.adaptive(
                                  key: const Key('switchSound'),
                                  value: state.isSoundOn,
                                  onChanged: (val) {
                                    final settingCubit =
                                        context.read<SettingCubit>();

                                    settingCubit
                                        .toggleSoundOption(val: val)
                                        .then((value) {
                                      if (val && state.isMute) {
                                        settingCubit.toggleMuteOption(
                                          val: !val,
                                        );
                                      }
                                      if (!val && !state.isMusicOn) {
                                        settingCubit.toggleMuteOption(
                                          val: !val,
                                        );
                                      }
                                    });
                                  },
                                ),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.volume_down,
                                  color: themeState.primaryTextColor,
                                  size: 40,
                                ),
                                minLeadingWidth: 0,
                                title: Text(
                                  context.l10n.musicSettings,
                                  style: TextStyle(
                                    color: themeState.primaryTextColor,
                                    fontSize: 22,
                                  ),
                                ),
                                trailing: Switch.adaptive(
                                  key: const Key('switchMusic'),
                                  value: state.isMusicOn,
                                  onChanged: (val) {
                                    final settingCubit =
                                        context.read<SettingCubit>();
                                    settingCubit
                                        .toggleMusicOption(val: val)
                                        .then((value) {
                                      if (state.isMute && val) {
                                        settingCubit.toggleMuteOption(
                                          val: !val,
                                        );
                                      }
                                      if (!val && !state.isSoundOn) {
                                        settingCubit.toggleMuteOption(
                                          val: !val,
                                        );
                                      }
                                    });
                                  },
                                ),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.dark_mode,
                                  color: themeState.primaryTextColor,
                                  size: 40,
                                ),
                                minLeadingWidth: 0,
                                title: Text(
                                  context.l10n.darkModeSettings,
                                  style: TextStyle(
                                    color: themeState.primaryTextColor,
                                    fontSize: 22,
                                  ),
                                ),
                                trailing: Switch.adaptive(
                                  key: const Key('switchDark'),
                                  value: state.isDarkMode,
                                  onChanged: (val) => context
                                      .read<SettingCubit>()
                                      .toggleDarkModeOption(val: val),
                                ),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.music_off,
                                  color: themeState.primaryTextColor,
                                  size: 40,
                                ),
                                minLeadingWidth: 0,
                                title: Text(
                                  context.l10n.muteSettings,
                                  style: TextStyle(
                                    color: themeState.primaryTextColor,
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
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
