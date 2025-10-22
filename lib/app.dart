// Copyright (c) 2022, AGTR Labs
// coverage:ignore-file
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sozzle/core/routes/routes.dart';
import 'package:sozzle/l10n/arb/app_localizations.dart';
import 'package:sozzle/src/apploader/application/apploader_repository.dart';
import 'package:sozzle/src/apploader/cubit/apploader_cubit.dart';
import 'package:sozzle/src/audio/audio_controller.dart';
import 'package:sozzle/src/audio/domain/i_audio_controller.dart';
import 'package:sozzle/src/level/application/level_repository.dart';
import 'package:sozzle/src/level/domain/i_level_repository.dart';
import 'package:sozzle/src/settings/application/setting_repository.dart';
import 'package:sozzle/src/settings/cubit/setting_cubit.dart';
import 'package:sozzle/src/settings/domain/i_setting_repository.dart';
import 'package:sozzle/src/theme/cubit/theme_cubit.dart';
import 'package:sozzle/src/user_stats/user_stats.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ILevelRepository>(
          create: (context) => LevelRepository(),
        ),
        RepositoryProvider<IUserStatsRepository>(
          create: (context) => UserStatsRepository(),
        ),
        RepositoryProvider<ISettingRepository>(
          create: (context) => SettingRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ThemeCubit(
              isDarkMode:
                  context.read<ISettingRepository>().getDarkModeSetting(),
            )..initialize(),
          ),
          BlocProvider(
            create: (context) => SettingCubit(
              settingRep: context.read<ISettingRepository>(),
              themeCubit: BlocProvider.of<ThemeCubit>(context),
            )..initialize(),
          ),
          BlocProvider(
            create: (context) => ApploaderCubit(
              apploaderRepository: MockApploaderRepository(
                levelRepository: context.read<ILevelRepository>(),
                userStatsRepository: context.read<IUserStatsRepository>(),
                settingRepository: context.read<ISettingRepository>(),
              ),
            ),
          ),
          BlocProvider(
            create: (context) => UserStatsCubit(
              context.read<IUserStatsRepository>(),
            )..readCurrentStats(),
          ),
        ],
        child: RepositoryProvider<IAudioController>(
          create: (context) => AudioController(
            settingsCubit: context.read<SettingCubit>(),
            initialSettings: context.read<SettingCubit>().state,
          ),
          child: BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, theme) {
              return MaterialApp.router(
                routerConfig: router,
                // routeInformationProvider: router.routeInformationProvider,
                // routeInformationParser: router.routeInformationParser,
                // routerDelegate: router.routerDelegate,
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  appBarTheme: AppBarTheme(backgroundColor: theme.appBarColor),
                  colorScheme: ColorScheme.fromSwatch(
                    accentColor: theme.accentColor,
                    primarySwatch: theme.primarySwatch,
                  ),
                  checkboxTheme: CheckboxThemeData(
                    fillColor: WidgetStateProperty.resolveWith<Color?>(
                        (Set<WidgetState> states) {
                      if (states.contains(WidgetState.disabled)) {
                        return null;
                      }
                      if (states.contains(WidgetState.selected)) {
                        return theme.primarySwatch;
                      }
                      return null;
                    }),
                  ),
                  radioTheme: RadioThemeData(
                    fillColor: WidgetStateProperty.resolveWith<Color?>(
                        (Set<WidgetState> states) {
                      if (states.contains(WidgetState.disabled)) {
                        return null;
                      }
                      if (states.contains(WidgetState.selected)) {
                        return theme.primarySwatch;
                      }
                      return null;
                    }),
                  ),
                  switchTheme: SwitchThemeData(
                    thumbColor: WidgetStateProperty.resolveWith<Color?>(
                        (Set<WidgetState> states) {
                      if (states.contains(WidgetState.disabled)) {
                        return null;
                      }
                      if (states.contains(WidgetState.selected)) {
                        return theme is ThemeStateDark
                            ? Colors.white
                            : theme.accentColor;
                      }

                      return theme.accentColor;
                    }),
                    trackColor: WidgetStateProperty.resolveWith<Color?>(
                        (Set<WidgetState> states) {
                      if (states.contains(WidgetState.disabled)) {
                        return null;
                      }
                      if (states.contains(WidgetState.selected)) {
                        return theme.primarySwatch;
                      }
                      return null;
                    }),
                  ),
                ),
                // builder: DevicePreview.appBuilder,
                // locale: DevicePreview.locale(context),
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                ],
                supportedLocales: AppLocalizations.supportedLocales,
              );
            },
          ),
        ),
      ),
    );
  }
}
