// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:go_router/go_router.dart';
// import 'package:sozzle/l10n/l10n.dart';
// import 'package:sozzle/src/common/border_elevated_button.dart';
// import 'package:sozzle/src/settings/cubit/setting_cubit.dart';
// import 'package:sozzle/src/settings/view/settings_page.dart';
// import 'package:sozzle/src/theme/cubit/theme_cubit.dart';

// void main() {
//   late final Widget app;
//   late final GoRouter router;
//   setUp(() {
//     router = GoRouter(
//       routes: <GoRoute>[
//         GoRoute(
//           path: '/',
//           builder: (context, GoRouterState state) => const BorderElevatedButton(
//             backgroundColor: Colors.blue,
//             borderColor: Colors.white,
//             route: '/settings',
//             text: 'Content',
//             textColor: Colors.white,
//           ),
//           routes: <GoRoute>[
//             GoRoute(
//               path: 'settings',
//               builder: (context, GoRouterState state) => const SettingsPage(),
//             ),
//           ],
//         ),
//       ],
//     );

//     app = MultiBlocProvider(
//       providers: [
//         BlocProvider<ThemeCubit>(
//           create: (context) => ThemeCubit(),
//         ),
//         BlocProvider<SettingCubit>(
//           create: (context) => SettingCubit(
//             BlocProvider.of<ThemeCubit>(context),
//           ),
//         ),
//       ],
//       child: MaterialApp.router(
//         routeInformationProvider: router.routeInformationProvider,
//         routeInformationParser: router.routeInformationParser,
//         routerDelegate: router.routerDelegate,
//         localizationsDelegates: const [
//           AppLocalizations.delegate,
//           GlobalMaterialLocalizations.delegate,
//         ],
//         supportedLocales: AppLocalizations.supportedLocales,
//       ),
//     );
//   });

//   testWidgets('test routing of BorderElevatedButton',
//       (WidgetTester tester) async {
//     await tester.pumpWidget(app);
//     final textFinder = find.text('Content');

//     expect(textFinder, findsOneWidget);
//     final button = find.byType(ElevatedButton);
//     expect(find.byType(SettingsPage), findsNothing);

//     await tester.tap(button);
//     await tester.pumpAndSettle();

//     expect(find.byType(SettingsPage), findsOneWidget);
//   });
// }
