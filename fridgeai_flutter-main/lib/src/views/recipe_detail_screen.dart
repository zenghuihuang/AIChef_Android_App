import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/recipe_api.dart';
import '../controllers/recipe_detail_controller.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late Recipe detailedRecipe;
  bool isLoading = true; // Assuming we start with loading to true
  final RecipeDetailController _controller = RecipeDetailController();



  @override
  void initState() {
    super.initState();
    // Initialize detailedRecipe with the passed recipe
    _controller.detailedRecipe = widget.recipe;
    // Fetch details if needed and update UI
    _controller.fetchRecipeDetails(widget.recipe).then((_) {
      if (mounted) {
        setState(() {
        });
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(_controller.detailedRecipe.title),
              background: Image.network(
                _controller.detailedRecipe.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        'Ingredients:',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 5),
                      // Ingredients list without icons and more compact
                      if (_controller.detailedRecipe.ingredients != null)
                        for (var ingredient in _controller.detailedRecipe.ingredients!)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2.0),
                            child: Text("- $ingredient", style: Theme.of(context).textTheme.bodyMedium),
                          ),
                      const SizedBox(height: 10),
                      Text(
                        'Instructions:',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 5),
                      // Numbered instructions with added color
                      if (_controller.detailedRecipe.instructions != null)
                        ..._controller.detailedRecipe.instructions!.asMap().entries.map(
                              (entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Text(
                              "${entry.key + 1}. ${entry.value}",
                              style: const TextStyle(color: Colors.blueGrey), // Adding color to the instruction text
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
