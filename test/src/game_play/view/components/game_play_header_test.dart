// TODO(Test): Rive causes this to fail, so, restore this test after the next
//  Rive major update when the issue is fixed

void main() {
  // setUpAll(() {
  //   unawaited(RiveFile.initialize());
  // });

  // group('GamePlayHeader', () {
  //   late MockUserStatsCubit userStatsCubit;
  //   late UserStatsState userStatsState;
  //   late MockThemeCubit themeCubit;
  //   setUp(() {
  //     userStatsCubit = MockUserStatsCubit();
  //     userStatsState = UserStatsState.initial();
  //     themeCubit = MockThemeCubit();
  //     whenListen<UserStatsState>(
  //       userStatsCubit,
  //       Stream.value(userStatsState),
  //       initialState: userStatsState,
  //     );
  //     whenListen<ThemeState>(
  //       themeCubit,
  //       Stream.value(const ThemeStateDark()),
  //       initialState: const ThemeStateDark(),
  //     );
  //   });
  //   testWidgets('should display current level', (WidgetTester tester) async {
  //     await tester.pumpApp(
  //       MultiBlocProvider(
  //         providers: [
  //           BlocProvider<UserStatsCubit>(
  //             create: (context) => userStatsCubit,
  //           ),
  //           BlocProvider<ThemeCubit>(
  //             create: (context) => themeCubit,
  //           ),
  //         ],
  //         child: const GamePlayHeader(),
  //       ),
  //     );
  //     await tester.pump();
  //     final futureFinder =
  //         find.text('Level ${userStatsState.progress.currentLevel}');
  //     await tester.pump();
  //     expect(futureFinder, findsOneWidget);
  //   });
  //   testWidgets('should display current level', (WidgetTester tester) async {
  //     await tester.pumpApp(
  //       MultiBlocProvider(
  //         providers: [
  //           BlocProvider<UserStatsCubit>(
  //             create: (context) => userStatsCubit,
  //           ),
  //           BlocProvider<ThemeCubit>(
  //             create: (context) => themeCubit,
  //           ),
  //         ],
  //         child: const GamePlayHeader(),
  //       ),
  //     );
  //     await tester.pump();
  //     final futureFinder =
  //         find.text('Level ${userStatsState.progress.currentLevel}');
  //     await tester.pump();
  //     expect(futureFinder, findsOneWidget);
  //   });
  // });
}
