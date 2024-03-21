import '../models/recipe.dart';
import '../services/recipe_api.dart';

class RecipeDetailController {
  final RecipeApi api = RecipeApi();
  late Recipe detailedRecipe;
  bool isLoading = true;

  Future<void> fetchRecipeDetails(Recipe recipe) async {
    if (recipe.ingredients == null || recipe.instructions == null) {
      try {
        Map<String, dynamic>? fetchedDetailsJson = await api.getRecipeInformation(recipe.id);
        if (fetchedDetailsJson != null) {
          detailedRecipe = Recipe.fromJson(fetchedDetailsJson);
          isLoading = false;
        } else {
          print('Failed to fetch recipe details.');
          isLoading = false;
        }
      } catch (e) {
        print('Error fetching recipe details: $e');
        isLoading = false;
      }
    } else {
      detailedRecipe = recipe;
      isLoading = false;
    }
  }
}

