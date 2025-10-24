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
  ViewModelInstance? _viewModelInstance;
  ViewModelInstanceBoolean? _luminance;
  ViewModelInstanceBoolean? _theme;
  ViewModelInstanceNumber? _hintCount;
  ViewModelInstanceColor? _textColour;

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
    _onInit();
    setState(() {});
  }

  void _onInit() {
    _viewModelInstance = _controller.dataBind(DataBind.auto());

    _luminance = _viewModelInstance?.boolean('isLightOn');
    _theme = _viewModelInstance?.boolean('isDarkTheme');
    _hintCount = _viewModelInstance?.number('hintCount');
    _textColour = _viewModelInstance?.color('textColour');
    final statsState = context.read<UserStatsCubit>().state;
    flipBulbByBooster(statsState);
    final themeState = context.read<ThemeCubit>().state;
    _theme?.value = themeState is ThemeStateDark;
    _textColour?.value = themeState.primaryTextColor;
    _hintCount?.value = statsState.progress.boosters
        .whereType<UseAHint>()
        .first
        .boosterCount
        .toDouble();
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

  bool hasHint(UserStatsState statsState) {
    return statsState.progress.boosters.any(
      (booster) => booster is UseAHint && booster.boosterCount > 0,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _viewModelInstance?.dispose();
    _textColour?.dispose();
    _hintCount?.dispose();
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
          _textColour?.value = themeState.primaryTextColor;
        },
        builder: (context, themeState) {
          return BlocConsumer<UserStatsCubit, UserStatsState>(
            listener: (context, statsState) {
              flipBulbByBooster(statsState);
              _hintCount?.value = statsState.progress.boosters
                  .whereType<UseAHint>()
                  .first
                  .boosterCount
                  .toDouble();
            },
            builder: (context, statsState) {
              final userHasHint = hasHint(statsState);

              return SizedBox(
                height: 100,
                width: 100,
                child: GestureDetector(
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
                  child: RiveWidget(key: UniqueKey(), controller: _controller),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
