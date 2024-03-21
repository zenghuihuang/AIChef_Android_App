import 'package:test/test.dart';
import '../../lib/src/models/ingredient.dart';
//Unit test for ingredient model
void main() {
  group('Ingredient Model Tests', () {
    test('should convert Ingredient to Map', () {
      final ingredient = Ingredient(
        id: 1,
        name: 'Tomato',
        amount: 5,
        bestBeforeDate: DateTime.parse('2024-01-01'),
      );

      final ingredientMap = ingredient.toMap();

      expect(ingredientMap['id'], 1);
      expect(ingredientMap['name'], 'Tomato');
      expect(ingredientMap['amount'], 5);
      expect(ingredientMap['bestBeforeDate'], '2024-01-01T00:00:00.000');
    });

    test('should convert Map to Ingredient', () {
      final map = {
        'id': 1,
        'name': 'Tomato',
        'amount': 5,
        'bestBeforeDate': '2024-01-01T00:00:00.000',
      };

      final ingredient = Ingredient.fromMap(map);

      expect(ingredient.id, 1);
      expect(ingredient.name, 'Tomato');
      expect(ingredient.amount, 5);
      expect(
        ingredient.bestBeforeDate,
        DateTime.parse('2024-01-01T00:00:00.000'),
      );
    });


  });
}
