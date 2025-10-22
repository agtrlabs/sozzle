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
import 'package:sozzle/src/game_play/bloc/game_play_bloc.dart';
import 'package:sozzle/src/game_play/domain/entities/booster.dart';
import 'package:sozzle/src/theme/theme.dart';
import 'package:sozzle/src/user_stats/cubit/user_stats_cubit.dart';

class Hint extends StatefulWidget {
  const Hint({super.key});

  @override
  State<Hint> createState() => _HintState();
}

class _HintState extends State<Hint> {
  File? _hintFile;
  late RiveWidgetController _controller;
  late StateMachine? _stateController;
  late StateMachine? _themeController;
  BooleanInput? _luminance;
  BooleanInput? _theme;

  @override
  void initState() {
    super.initState();
    preload();
  }

  Future<void> preload() async {
    final data = await rootBundle.load(Media.animatedHint);
    _hintFile = await File.decode(
      data.buffer.asUint8List(),
      riveFactory: Factory.rive,
    );
    _controller = RiveWidgetController(_hintFile!);
    _onInit(_controller.artboard);
    setState(() {});
  }

  void _onInit(Artboard artboard) {
    _stateController = artboard.stateMachine('bulb');
    _themeController = artboard.stateMachine('theme');
    _luminance = _stateController?.boolean('pressed');
    _theme = _themeController?.boolean('isDark');
    flipBulbByBooster(context.read<UserStatsCubit>().state);
    _theme?.value = context.read<ThemeCubit>().state is ThemeStateDark;
  }

  void flipBulbByBooster(UserStatsState statsState) {
    final userHasHint = statsState.progress.boosters.any(
      (booster) => booster is UseAHint && booster.boosterCount > 0,
    );
    if (userHasHint) {
      _luminance?.value = true;
    } else {
      _luminance?.value = false;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _stateController?.dispose();
    _themeController?.dispose();
    _luminance?.dispose();
    _theme?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hintFile == null) return const SizedBox.shrink();
    return Tooltip(
      message: 'Use a hint',
      child: BlocConsumer<ThemeCubit, ThemeState>(
        listener: (context, themeState) {
          _theme?.value = themeState is ThemeStateDark;
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
                          context.read<GamePlayBloc>().add(
                                const RevealRandomLetterEvent(),
                              );
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
                        child: RiveWidget(
                          key: UniqueKey(),
                          controller: _controller,
                          fit: Fit.cover,
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
