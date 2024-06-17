import 'package:flutter_test/flutter_test.dart';
import 'package:localstore/localstore.dart';
import 'package:sozzle/app.dart';
import 'package:sozzle/src/splash/splash_page.dart';

void main() {
  group('App', () {
    late App myApp;
    const wait = Duration(seconds: 1);
    setUp(() async {
      myApp = const App();
      await Localstore.instance.collection('stats').doc('current').delete();
    });

    testWidgets('renders SplashPage', (tester) async {
      await tester.pumpWidget(myApp);
      await tester.pump(wait);
      await tester.pump(wait);
      await tester.pump(wait);
      await tester.pump(const Duration(seconds: 10));
      expect(find.byType(SplashPage), findsOneWidget);
    });

    // testWidgets('renders HomePage onTap StartButton', (tester) async {
    //   await tester.pumpWidget(myApp);
    //   await tester.pump(wait);
    //   await tester.tap(find.byType(StartButton));
    //   await tester.pumpAndSettle();
    //   expect(find.byType(HomePage), findsOneWidget);
    // });
  });
}
