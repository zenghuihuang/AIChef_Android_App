import 'package:flutter_test/flutter_test.dart';
import '../../lib/src/models/recipe.dart';

void main() {
  group('Recipe Class Tests', () {
    test('toMap correctly converts a Recipe instance to Map', () {
      final recipe = Recipe(
        id: 1,
        title: "Test Recipe",
        imageUrl: "http://example.com/image1.jpg",
        servings: 4,
        readyInMinutes: 30,
        ingredients:["Salt","Pepper"],
        instructions: ["Step 1","Step 2"],
        isLiked: true,
      );

      final recipeMap = recipe.toMap();


      expect(recipeMap, equals({
        'id': 1,
        'title': "Test Recipe",
        'imageUrl': "http://example.com/image1.jpg",
        'servings': 4,
        'readyInMinutes': 30,
        'ingredients': "Salt,Pepper",
        'instructions': "Step 1||Step 2",
        'isLiked': 1,
      }));
    });

    test('fromMap correctly creates a Recipe instance from Map', () {
      final map = {
        'id': 1,
        'title': "Test Recipe",
        'imageUrl': "http://example.com/image.jpg",
        'servings': 4,
        'readyInMinutes': 30,
        'ingredients': "Salt,Pepper",
        'instructions': "Step 1||Step 2",
        'isLiked': 1,
      };

      final recipe = Recipe.fromMap(map);

      expect(recipe.id, 1);
      expect(recipe.title, "Test Recipe");
      expect(recipe.imageUrl, "http://example.com/image.jpg");
      expect(recipe.servings, 4);
      expect(recipe.readyInMinutes, 30);
      expect(recipe.ingredients, ["Salt", "Pepper"]);
      expect(recipe.instructions, ["Step 1", "Step 2"]);
      expect(recipe.isLiked, true);
    });

    test('fromJson correctly creates a Recipe instance from JSON', () {
      final json = {
        'id': 1,
        'title': "Test Recipe",
        'image': "http://example.com/image.jpg",
        'servings': 4,
        'readyInMinutes': 30,
        'extendedIngredients': [
          {'name': "Salt"},
          {'name': "Pepper"}
        ],
        'analyzedInstructions': [
          {
            'steps': [
              {'step': "Step 1"},
              {'step': "Step 2"}
            ]
          }
        ],
      };

      final recipe = Recipe.fromJson(json);

      expect(recipe.id, 1);
      expect(recipe.title, "Test Recipe");
      expect(recipe.imageUrl, "http://example.com/image.jpg");
      expect(recipe.servings, 4);
      expect(recipe.readyInMinutes, 30);
      expect(recipe.ingredients, ["Salt", "Pepper"]);
      expect(recipe.instructions, ["Step 1", "Step 2"]);
      expect(recipe.isLiked, false);
    });
  });
}
