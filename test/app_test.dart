import 'package:flutter_test/flutter_test.dart';
import 'package:sozzle/app.dart';
import 'package:sozzle/src/splash/splash_page.dart';

void main() {
  group('App', () {
    late App myApp;
    const wait = Duration(seconds: 1);
    setUp(() async {
      myApp = const App();
    });

    testWidgets('renders SplashPage', (tester) async {
      await tester.pumpWidget(myApp);
      await tester.pump(wait);
      
      await tester.pump(wait);
      await tester.pump(wait);
      await tester.pump(Duration(seconds: 10));
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
