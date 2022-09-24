import 'package:flutter_test/flutter_test.dart';
import 'package:sozzle/app.dart';
import 'package:sozzle/src/home/view/home_page.dart';
import 'package:sozzle/src/splash/splash_page.dart';

void main() {
  group('App', () {

    late App myApp;

    setUp(() async {
      myApp = const App();
    });
    
    Future<void> appinit(WidgetTester tester) async {
      await tester.pumpWidget(myApp);
      await tester.pump(const Duration(seconds: 20));
    }

    testWidgets('renders SplashPage', (tester) async {
      await appinit(tester);
      expect(find.byType(SplashPage), findsOneWidget);
    });
    testWidgets('renders StartButton', (tester) async {
      await appinit(tester);
      expect(find.byType(StartButton), findsOneWidget);
    });

    testWidgets('renders HomePage onTap StartButton', (tester) async {
      await appinit(tester);
      await tester.tap(find.byType(StartButton));
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
