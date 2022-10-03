import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sozzle/src/settings/cubit/setting_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingCubit, SettingState>(
      builder: (context, state) {
        if (state is SettingInitial) {
          return Drawer(
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: const Text('Sound'),
                  trailing: Switch.adaptive(
                    value: state.isSoundOn,
                    onChanged: (_) =>
                        context.read<SettingCubit>().toggleSoundOption(),
                  ),
                ),
                ListTile(
                  title: const Text('Music'),
                  trailing: Switch.adaptive(
                    value: state.isMusicOn,
                    onChanged: (_) =>
                        context.read<SettingCubit>().toggleMusicOption(),
                  ),
                ),
                ListTile(
                  title: const Text('Dark Mode'),
                  trailing: Switch.adaptive(
                    value: state.isDarkMode,
                    onChanged: (_) =>
                        context.read<SettingCubit>().toggleDarkModeOption(),
                  ),
                ),
                ListTile(
                  title: const Text('Mute'),
                  trailing: Switch.adaptive(
                    value: state.isMute,
                    onChanged: (_) =>
                        context.read<SettingCubit>().toggleMuteOption(),
                  ),
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
