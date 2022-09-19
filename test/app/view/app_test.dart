import 'package:flutter_test/flutter_test.dart';
import 'package:sozzle/app.dart';
import 'package:sozzle/src/splash/splash_page.dart';

void main() {
  group('App', () {
    testWidgets('renders SplashPage', (tester) async {
      await tester.pumpWidget(const App());
      await tester.pump(const Duration(seconds: 10));
      expect(find.byType(SplashPage), findsOneWidget);
    });
  });
}
