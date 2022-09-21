import 'package:flutter_test/flutter_test.dart';
import 'package:sozzle/app.dart';
import 'package:sozzle/src/home/view/home_page.dart';
import 'package:sozzle/src/splash/splash_page.dart';

void main() {
  group('App', () {
    Future<void> appinit(WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pump(const Duration(seconds: 2));
      await tester.pump(const Duration(seconds: 2));
      await tester.pump(const Duration(seconds: 2));
      await tester.pump(const Duration(seconds: 2));
      await tester.pump(const Duration(seconds: 10));
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
