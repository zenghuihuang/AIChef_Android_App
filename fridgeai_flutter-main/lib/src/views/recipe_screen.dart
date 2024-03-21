import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/ingredient.dart';
import '../models/recipe.dart';
import '../services/recipe_api.dart';
import '../utils/database.dart';
import 'recipe_detail_screen.dart';
import '../controllers/recipe_screen_controller.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key});

  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  final RecipeScreenController _controller = RecipeScreenController();
  List<Recipe> recipes = [];
  bool isLoading = false; // Initially set to false

  @override
  void initState() {
    super.initState();
    _initRecipes();
    //loadFavoriteRecipes(); // Load favorite recipes from the database
    // Remove the fetchRecipes call from here
  }
  Future<void> _initRecipes() async {
    await _controller.loadFavoriteRecipes();
    if (mounted) {
      setState(() {});
    }
  }


  void _showSearchRecipeModal() async {
    List<Ingredient> ingredients = await DatabaseHelper.instance.getIngredientsSortedByDate();

    // Mark all ingredients as not selected initially.
    for (var ingredient in ingredients) {
      ingredient.isSelected = false;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Make modal full screen to accommodate for keyboard
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9, // Modal sheet initial size
          maxChildSize: 0.9, // Modal sheet max size
          builder: (_, controller) {
            return StatefulBuilder( // Use StatefulBuilder to manage the state of checkboxes
              builder: (BuildContext context, StateSetter setModalState) {
                return Container(
                  padding: const EdgeInsets.only(top: 16),
                  child: Column(
                    children: [
                      const Text(
                        "Select ingredients for your recipes",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: ListView.builder(
                          controller: controller, // Enable scrolling within DraggableScrollableSheet
                          itemCount: ingredients.length,
                          itemBuilder: (BuildContext context, int index) {
                            // TODO: move this logic into a function that should live inside the controller

                            Ingredient ingredient = ingredients[index];
                            bool isExpiringSoon = ingredient.bestBeforeDate.isBefore(DateTime.now().add(const Duration(days: 5)));

                            return ListTile(
                              title: Text(ingredient.name),
                              subtitle: Text(
                                'Best before: ${DateFormat('yyyy-MM-dd').format(ingredient.bestBeforeDate)}',
                                style: TextStyle(color: isExpiringSoon ? Colors.red : Colors.black),
                              ),
                              trailing: Checkbox(
                                value: ingredient.isSelected,
                                onChanged: (bool? value) {
                                  setModalState(() { // Use setModalState to update the UI
                                    ingredients[index].isSelected = value ?? false;
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          List<String> selectedIngredientsNames = ingredients
                              .where((ingredient) => ingredient.isSelected)
                              .map((ingredient) => ingredient.name)
                              .toList();
                          Navigator.pop(context); // Close the modal
                          _fetchAndSetRecipes(selectedIngredientsNames);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50), // Make the button wider and taller
                        ),
                        child: const Text('Confirm Selection'),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
  Future<void> _fetchAndSetRecipes(List<String> selectedIngredientsNames) async {
    await _controller.fetchRecipes(selectedIngredientsNames); // Wait for the fetch operation to complete
    if (mounted) {
      setState(() {
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes'),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            // Ensure the button stretches to the full width of the screen
            padding: const EdgeInsets.all(8.0),
            // Add some padding around the button
            child: ElevatedButton(
              onPressed: _showSearchRecipeModal,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                // Increase button's height
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      0), // Optional: if you prefer squared buttons
                ),
                backgroundColor: Colors.blue
              ),
              child: const Text('Search Recipe', style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
          ),
          Expanded(
            child: _controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: _controller.recipes.length,
              itemBuilder: (context, index) {
                final recipe = _controller.recipes[index];
                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RecipeDetailScreen(recipe: recipe),
                        ),
                      );
                    },
                    leading: Image.network(recipe.imageUrl, width: 100,
                        height: 100,
                        fit: BoxFit.cover),
                    title: Text(recipe.title),
                    trailing: IconButton(
                      icon: Icon(recipe.isLiked ? Icons.favorite : Icons
                          .favorite_border),
                      color: recipe.isLiked ? Colors.red : null,
                      onPressed: () async {
                        setState(() {
                          recipe.isLiked = !recipe.isLiked;
                        });
                        await DatabaseHelper.instance.insertOrUpdateRecipe(recipe);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
