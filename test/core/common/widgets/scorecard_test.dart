import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rive/rive.dart';
import 'package:sozzle/core/common/widgets/scorecard.dart';
import 'package:sozzle/src/theme/cubit/theme_cubit.dart';

import '../../../helpers/helpers.dart';

void main() {
  late ThemeCubit themeCubit;

  setUpAll(RiveNative.init);

  setUp(() {
    themeCubit = MockThemeCubit();
    when(() => themeCubit.state).thenReturn(const ThemeStateLight());
  });

  testWidgets('Scorecard finds rive widget', (tester) async {
    await tester.pumpApp(
      BlocProvider.value(
        value: themeCubit,
        child: const Scorecard(level: 1, failedAttempts: '0'),
      ),
    );

    expect(find.byType(Scorecard), findsOneWidget);
  });
}
