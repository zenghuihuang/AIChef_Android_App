// import 'package:integration_test/integration_test.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_test/src/test_compat.dart';
// import 'package:test_core/src/scaffolding.dart';
// import 'package:test/test.dart';
// import 'package:fridge_ai_flutter/src/utils/database.dart';
//
// void main() {
//   IntegrationTestWidgetsFlutterBinding.ensureInitialized();
//
//   group('Database Integration Tests', () {
//     testWidgets('Test database operations', (WidgetTester tester) async {
//       // Instantiate your database helper
//       final db = DatabaseHelper.instance;
//
//       // Test adding a new ingredient
//       await db.insertIngredient({
//         'name': 'Tomato',
//         'amount': 2,
//         'bestBeforeDate': '2022-04-20',
//       });
//
//       // Test retrieving ingredients
//       final ingredients = await db.getIngredientsSortedByDate();
//       expect(ingredients, isNotEmpty);
//
//       // Test updating an ingredient
//       final updatedIngredient = {
//         'id': ingredients.first.id,
//         'name': 'Tomato',
//         'amount': 5,
//         'bestBeforeDate': '2022-04-25',
//       };
//       await db.updateIngredient(updatedIngredient);
//       final updatedIngredients = await db.getIngredientsSortedByDate();
//       expect(updatedIngredients.first.amount, equals(5));
//
//       // Test deleting an ingredient
//       await db.deleteIngredientByName('Tomato');
//       final postDeleteIngredients = await db.getIngredientsSortedByDate();
//       expect(postDeleteIngredients, isEmpty);
//
//       // Close the database
//       await db.close();
//     });
//   });
// }
