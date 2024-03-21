import 'dart:convert';
import 'package:http/http.dart' as http;

class RecipeApi {
  static const String _apiKey = '2fd4b8f1d5c34fc1ac267de4e3177bda';
  static const String _baseUrl = 'https://api.spoonacular.com';

  // Function to fetch recipes by ingredients
  Future<List<dynamic>?> fetchRecipesByIngredients(List<String> ingredients) async {
    final String ingredientsQuery = ingredients.join(',');
    final String url = '$_baseUrl/recipes/findByIngredients?ingredients=$ingredientsQuery&apiKey=$_apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Parse the JSON response and return
        return json.decode(response.body) as List;
      } else {
        // Handle non-200 responses
        print('Failed to load recipes: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // Handle any exceptions
      print('Error fetching recipes: $e');
      return null;
    }
  }

  // Function to get recipe information by ID
  Future<Map<String, dynamic>?> getRecipeInformation(int recipeId) async {
    final String url = '$_baseUrl/recipes/$recipeId/information?includeNutrition=false&apiKey=$_apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        print('Failed to load recipe information: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching recipe information: $e');
      return null;
    }
  }

}
