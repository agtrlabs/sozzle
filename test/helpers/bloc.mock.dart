import 'package:bloc_test/bloc_test.dart';
import 'package:sozzle/src/apploader/apploader.dart';
import 'package:sozzle/src/game_play/bloc/game_play_bloc.dart';
import 'package:sozzle/src/settings/cubit/setting_cubit.dart';
import 'package:sozzle/src/theme/cubit/theme_cubit.dart';
import 'package:sozzle/src/user_stats/cubit/user_stats_cubit.dart';

class MockThemeCubit extends MockCubit<ThemeState> implements ThemeCubit {}

class MockUserStatsCubit extends MockCubit<UserStatsState>
    implements UserStatsCubit {}

class MockSettingsCubit extends MockCubit<SettingState>
    implements SettingCubit {}

class MockAppLoaderCubit extends MockCubit<ApploaderState>
    implements ApploaderCubit {}

class MockGamePlayBloc extends MockBloc<GamePlayEvent, GamePlayState>
    implements GamePlayBloc {}
