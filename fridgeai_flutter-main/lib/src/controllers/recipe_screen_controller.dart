import '../models/recipe.dart';
import '../services/recipe_api.dart';
import '../utils/database.dart';

class RecipeScreenController {
  List<Recipe> recipes = [];
  bool isLoading = false;

  Future<void> loadFavoriteRecipes() async {
    List<Recipe> favoriteRecipes = await DatabaseHelper.instance.getLikedRecipes();
    recipes = favoriteRecipes;
  }


  Future<void> fetchRecipes(List<String> selectedIngredients) async {
    isLoading = true;
    try {
      List<dynamic>? fetchedRecipes = await RecipeApi().fetchRecipesByIngredients(selectedIngredients);
      if (fetchedRecipes != null) {
        recipes = fetchedRecipes.map((recipeJson) => Recipe.fromJson(recipeJson)).toList();
      }
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading = false;
    }
  }



}
