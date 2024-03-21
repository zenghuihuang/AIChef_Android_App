import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fridge_ai_flutter/src/views/trolley_screen.dart';


void main() {
  group('TrolleyScreen Widget Tests', () {
    // Test for AppBar presence
    testWidgets('AppBar should display with correct title', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: TrolleyScreen()));
      expect(find.text('Trolley'), findsOneWidget);
    });

    // Test for FloatingActionButton presence
    testWidgets('FloatingActionButton should be present', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: TrolleyScreen()));
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });


  });
}
