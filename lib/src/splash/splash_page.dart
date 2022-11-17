import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sozzle/l10n/l10n.dart';
import 'package:sozzle/src/apploader/cubit/apploader_cubit.dart';
import 'package:sozzle/src/home/home.dart';
import 'package:sozzle/src/settings/cubit/setting_cubit.dart';
import 'package:sozzle/src/theme/cubit/theme_cubit.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  static const String path = '/splash';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool a = false;
  bool b = false;
  bool c = false;
  bool d = false;
  bool e = false;
  int counter = 0;
  static const colorizeColors = [
    Colors.purple,
    Colors.blue,
    Colors.yellow,
    Colors.red,
  ];

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      counter += 100;
      switch (counter) {
        case 400:
          a = true;
          b = true;
          break;
        case 1300:
          c = true;
          break;
        case 1700:
          e = true;
          break;
        case 3400:
          d = true;
          timer.cancel();
          break;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final apploader = context.read<ApploaderCubit>();
    final mq = MediaQuery.of(context);
    final height = mq.size.height;
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return BlocBuilder<SettingCubit, SettingState>(
          builder: (_, settingState) {
            return Scaffold(
              backgroundColor: state.backgroundColor,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: d ? 900 : 2500),
                      curve:
                          d ? Curves.fastLinearToSlowEaseIn : Curves.elasticOut,
                      height: d
                          ? 0
                          : a
                              ? height / 2
                              : 20,
                      width: 20,
                    ),
                    if (d)
                      Text(
                        'Sozzle',
                        style: TextStyle(
                          color: state.primaryTextColor,
                          fontSize: 24,
                        ),
                      )
                    else
                      AnimatedContainer(
                        duration: Duration(seconds: c ? 2 : 0),
                        curve: Curves.fastLinearToSlowEaseIn,
                        height: c ? 80 : 20,
                        width: c ? 200 : 20,
                        decoration: BoxDecoration(
                          color: b
                              ? settingState.isDarkMode
                                  ? Colors.white
                                  : const Color(0xFF123456)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: e
                            ? Center(
                                child: AnimatedTextKit(
                                  totalRepeatCount: 1,
                                  animatedTexts: [
                                    ColorizeAnimatedText(
                                      'Sozzle',
                                      colors: colorizeColors,
                                      textStyle: const TextStyle(
                                        fontSize: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: BlocBuilder<ApploaderCubit, ApploaderState>(
                        builder: (context, state) {
                          if (state.loaderState == LoaderState.loadingPuzzle) {
                            return LinearProgressIndicator(
                              value: state.percent / 100,
                              color: d ? null : Colors.transparent,
                              backgroundColor: d ? null : Colors.transparent,
                            );
                          } else if (state.loaderState ==
                              LoaderState.loadingUserData) {
                            return LinearProgressIndicator(
                              value: state.percent / 100,
                              color: d ? null : Colors.transparent,
                              backgroundColor: d ? null : Colors.transparent,
                            );
                          } else if (state.loaderState ==
                              LoaderState.loadingSettingsData) {
                            return LinearProgressIndicator(
                              value: state.percent / 100,
                              color: d ? null : Colors.transparent,
                              backgroundColor: d ? null : Colors.transparent,
                            );
                          } else if (state.loaderState == LoaderState.loaded) {
                            return StartButton(
                              textColour: d ? null : Colors.transparent,
                            );
                          }
                          apploader.updatePuzzleData();
                          return Container();
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class StartButton extends StatelessWidget {
  const StartButton({
    super.key,
    this.textColour,
  });

  final Color? textColour;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return TextButton(
      child: Text(
        l10n.startButton,
        style: TextStyle(fontSize: 24, color: textColour),
      ),
      onPressed: () {
        context.go(HomePage.path);
      },
    );
  }
}
