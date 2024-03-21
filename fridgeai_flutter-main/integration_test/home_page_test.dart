import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fridge_ai_flutter/src/widgets/splash_screen.dart';
import 'package:integration_test/integration_test.dart';
import 'package:fridge_ai_flutter/src/views/home_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('HomePage Integration Tests', () {
    testWidgets("Floating Action Button Test", (tester) async {
      // Launch the app
      await tester.pumpWidget(HomePage());

      // Ensure the HomePage is displayed
      expect(find.byType(SplashScreen), findsOneWidget);

      // Find the FloatingActionButton and tap on it
      final Finder fab = find.byType(FloatingActionButton);
      expect(fab, findsOneWidget);
      await tester.tap(fab);
      await tester.pumpAndSettle(); // Wait for any animations to complete

      // After tapping the FAB, check if the dialog for adding a new ingredient appears
      expect(find.text('Add New Ingredient'), findsOneWidget);

      // Optionally, fill out the dialog fields and confirm the addition
      // For example, entering the name and quantity of the new ingredient
      await tester.enterText(find.byType(TextField).at(0), 'Tomatoes');
      await tester.enterText(find.byType(TextField).at(1), '5');
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      // Verify the ingredient has been added (This step might require a mock or a specific setup to verify)
    });
  });
}
