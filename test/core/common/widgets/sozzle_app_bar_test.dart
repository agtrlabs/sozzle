import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sozzle/core/common/widgets/sozzle_app_bar.dart';

void main() {
  testWidgets('SozzleAppBar', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          appBar: SozzleAppBar(
            title: 'Sozzle',
          ),
        ),
      ),
    );

    expect(find.byType(SozzleAppBar), findsOneWidget);
    expect(find.text('Sozzle'), findsOneWidget);
  });
}
