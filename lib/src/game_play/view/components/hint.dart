// coverage:ignore-file
// TODO(Test): Rive causes this to fail, so, test this test after the next
//  Rive major update when the issue is fixed
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart';
import 'package:sozzle/core/common/widgets/game_button.dart';
import 'package:sozzle/core/res/media.dart';
import 'package:sozzle/src/game_play/domain/entities/booster.dart';
import 'package:sozzle/src/theme/theme.dart';
import 'package:sozzle/src/user_stats/cubit/user_stats_cubit.dart';

class Hint extends StatefulWidget {
  const Hint({super.key});

  @override
  State<Hint> createState() => _HintState();
}

class _HintState extends State<Hint> {
  RiveFile? _hintFile;
  SMIBool? _luminance;
  SMIBool? _theme;

  @override
  void initState() {
    super.initState();
    preload();
  }

  void preload() {
    rootBundle.load(Media.animatedHint).then((data) {
      setState(() {
        _hintFile = RiveFile.import(data);
      });
    });
  }

  void _onInit(Artboard artboard) {
    final stateController = StateMachineController.fromArtboard(
      artboard,
      'bulb',
    );
    final themeController = StateMachineController.fromArtboard(
      artboard,
      'theme',
    );
    artboard
      ..addController(stateController!)
      ..addController(themeController!);
    _luminance = stateController.findInput<bool>('pressed')! as SMIBool;
    _theme = themeController.findInput<bool>('isDark')! as SMIBool;
    flipBulbByBooster(context.read<UserStatsCubit>().state);
    _theme?.change(context.read<ThemeCubit>().state is ThemeStateDark);
  }

  void flipBulbByBooster(UserStatsState statsState) {
    final userHasHint = statsState.progress.boosters.any(
      (booster) => booster is UseAHint && booster.boosterCount > 0,
    );
    if (userHasHint) {
      _luminance?.change(true);
    } else {
      _luminance?.change(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hintFile == null) return const SizedBox.shrink();
    return Tooltip(
      message: 'Use a hint',
      child: BlocConsumer<ThemeCubit, ThemeState>(
        listener: (context, themeState) {
          _theme?.change(themeState is ThemeStateDark);
        },
        builder: (context, themeState) {
          return BlocConsumer<UserStatsCubit, UserStatsState>(
            listener: (context, statsState) {
              flipBulbByBooster(statsState);
            },
            builder: (context, statsState) {
              final userHasHint = statsState.progress.boosters.any(
                (booster) => booster is UseAHint && booster.boosterCount > 0,
              );
              var hintCount = 0;
              if (userHasHint) {
                hintCount = statsState.progress.boosters
                    .whereType<UseAHint>()
                    .first
                    .boosterCount;
              }
              return GestureDetector(
                onTap: () {
                  if (userHasHint) {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.question,
                      animType: AnimType.rightSlide,
                      title: 'Reveal a letter?',
                      desc: 'Are you sure you want to use a hint?',
                      btnOk: GameButton(
                        text: 'Reveal',
                        onPressed: () {
                          Navigator.of(context).pop();
                          context.read<UserStatsCubit>().useAHint();
                        },
                      ),
                    ).show();
                    // context.read<UserStatsCubit>().useAHint();
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Baseline(
                      baselineType: TextBaseline.alphabetic,
                      baseline: 45,
                      child: SizedBox(
                        width: 50,
                        child: RiveAnimation.direct(
                          key: UniqueKey(),
                          _hintFile!,
                          fit: BoxFit.cover,
                          onInit: _onInit,
                        ),
                      ),
                    ),
                    Text(
                      hintCount.toString(),
                      style: TextStyle(
                        color: themeState.primaryTextColor,
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
