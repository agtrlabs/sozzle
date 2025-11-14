import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_core/game_core.dart';
import 'package:sozzle/l10n/l10n.dart';
import 'package:sozzle/src/common/border_elevated_button.dart';
import 'package:sozzle/src/theme/cubit/theme_cubit.dart';

class PlayButton extends StatelessWidget {
  const PlayButton(this.levelId, {super.key});
  final int levelId;

  @override
  Widget build(BuildContext context) => BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          final l10n = context.l10n;
          return BorderElevatedButton(
            onPressed: () {
              context.read<GameCoreBloc>().add(PlayLevelRequested(levelId));
            },
            text: l10n.startButton,
            backgroundColor: state.backgroundColor,
            borderColor: state.primaryTextColor,
            textColor: state.primaryTextColor,
          );
        },
      );
}
