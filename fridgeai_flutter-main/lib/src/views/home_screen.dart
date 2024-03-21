import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/ingredient.dart';
import '../models/shopping_item.dart';
import '../services/TrolleyService.dart';
import '../utils/database.dart';
import 'camera_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchQuery = '';
  final TextEditingController searchController = TextEditingController();
  List<Ingredient> ingredients =  [];

  List<Map<String, dynamic>> commonIngredients = [
    {
      'category': 'Vegetables',
      'ingredients': [
        {'name': 'Carrot'},
        {'name': 'Tomato'},
        {'name': 'Broccoli'},
        {'name': 'Cabbage'},
        {'name': 'Potato'},
        {'name': 'Onion'},
        {'name': 'Garlic'},
        {'name': 'Courgette'},
        {'name': 'Butternut squash'},
      ],
    },
    {
      'category': 'Fruits',
      'ingredients': [
        {'name': 'Apple'},
        {'name': 'Banana'},
        {'name': 'Orange'},
        {'name': 'Grapes'},
        {'name': 'Blueberries'},
        {'name': 'Strawberries'},
        {'name': 'Mango'},
        {'name': 'Watermelon'},

      ],
    },
  ];




  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
    _loadIngredients();
  }

  void _loadIngredients() async {
    final loadedIngredients = await DatabaseHelper.instance.getIngredients();
    setState(() {
      ingredients = loadedIngredients.map((item) => Ingredient.fromMap(item)).toList();
    });
  }
  void _onIngredientSelected(Map<String, dynamic> ingredient) async {
    Ingredient newIngredient = Ingredient(
      name: ingredient['name'],
      amount: 1, //
      bestBeforeDate: DateTime.now(),
    );
    await DatabaseHelper.instance.insertIngredient(newIngredient.toMap());
    _loadIngredients(); // Reload the ingredients to update the UI
  }

  void _onIngredientDeselected(Map<String, dynamic> ingredient) async {
    await DatabaseHelper.instance.deleteIngredientByName(ingredient['name']);
    _loadIngredients(); // Reload the ingredients to update the UI
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged); // Remove listener
    searchController.dispose(); // Dispose controller
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = searchController.text;
    });
  }





  // Getter to filter ingredients based on the search query
  List<Ingredient> get _filteredIngredients {
    if (_searchQuery.isEmpty) {
      return ingredients;
    } else {
      return ingredients.where((ingredient) => ingredient.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Column(
        children: [
          _buildTopSection(),
          _buildCommonIngredientsGrid(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "My Ingredients",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(child: _buildIngredientsList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewIngredient(context),
        heroTag: 'addIngredients',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTopSection() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            controller: searchController,
            decoration: const InputDecoration(
              labelText: 'Search',
              suffixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {

                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CameraScreen()));
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text("Identify"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommonIngredientsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: commonIngredients.map((category) {
        return CustomExpansionTile(
          title: category['category'],
          ingredients: category['ingredients'],
          onIngredientSelected: _onIngredientSelected,
          onIngredientDeselected: _onIngredientDeselected,
        );
      }).toList(),
    );
  }


  Widget _buildIngredientsList() {
    return ListView.builder(
      itemCount: _filteredIngredients.length,
      itemBuilder: (context, index) {
        final ingredient = _filteredIngredients[index];
        return Slidable(
          key: ValueKey(ingredient.id),
          endActionPane: ActionPane(
            motion: DrawerMotion(),
            children: [
              SlidableAction(
                onPressed: (_) async {
                  await DatabaseHelper.instance.deleteIngredientByName(ingredient.name);
                  setState(() {
                    _filteredIngredients.removeAt(index);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${ingredient.name} deleted successfully")),
                  );
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: Card(
            margin: const EdgeInsets.all(8.0),
            color: Colors.blue.shade50,
            child: ListTile(
              title: Text(ingredient.name),
              subtitle: Text(
                'Best before: ${ingredient.bestBeforeDate.toIso8601String().split('T')[0]}',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              trailing: Container(
                width: 130,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () async {
                        if (ingredient.amount >= 1) {
                          setState(() {
                            ingredient.amount -= 1;
                            if(ingredient.amount==0){
                              TrolleyService().addItemToTrolley(ShoppingItem(name: ingredient.name, quantity: 1));

                              print("Added ${ingredient.name} to trolley");

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("${ingredient.name} added to trolley")),
                              );

                            }
                          });
                          await DatabaseHelper.instance.updateIngredient(ingredient.toMap());
                        }
                      },
                    ),

                    SizedBox(width: 8),
                    Text('${ingredient.amount}'),
                    SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () async {
                        setState(() {
                          ingredient.amount += 1;
                        });
                        await DatabaseHelper.instance.updateIngredient(ingredient.toMap());
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }









  Future<void> _selectDate(BuildContext context, int index) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != ingredients[index].bestBeforeDate) {
      setState(() {
        ingredients[index].bestBeforeDate = picked;
      });
      await DatabaseHelper.instance.updateIngredient(ingredients[index].toMap());
    }
  }

  void _addNewIngredient(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    String name = '';
    int amount = 1;
    DateTime bestBeforeDate = DateTime.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        DateTime selectedDate = bestBeforeDate;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              title: const Text("Add New Ingredient"),
              content: SingleChildScrollView( // Wrap content with SingleChildScrollView
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Ingredient Name'),
                        validator: (value) => value == null || value.isEmpty ? 'Please enter a name' : null,
                        onSaved: (value) => name = value!,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Amount'),
                        keyboardType: TextInputType.number,
                        validator: (value) => value == null || value.isEmpty ? 'Please enter an amount' : null,
                        onSaved: (value) => amount = int.parse(value!),
                      ),
                      TextButton(
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2025),
                          );
                          if (picked != null && picked != selectedDate) {
                            setDialogState(() => selectedDate = picked);
                          }
                        },
                        child: Text('Best Before Date: ${selectedDate.toIso8601String().split('T')[0]}'),
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      Ingredient newIngredient = Ingredient(name: name, amount: amount, bestBeforeDate: selectedDate);
                      await DatabaseHelper.instance.insertIngredient(newIngredient.toMap());
                      Navigator.of(context).pop(); // Close the dialog
                      _loadIngredients(); // Reload ingredients from the database
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }


}

class CustomExpansionTile extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> ingredients;
  final Function(Map<String, dynamic>) onIngredientSelected;
  final Function(Map<String, dynamic>) onIngredientDeselected;

  CustomExpansionTile({
    required this.title,
    required this.ingredients,
    required this.onIngredientSelected,
    required this.onIngredientDeselected,
  });

  @override
  _CustomExpansionTileState createState() => _CustomExpansionTileState();
}



class _CustomExpansionTileState extends State<CustomExpansionTile> {
  bool _isExpanded = false;
  Set<int> _selectedIndices = Set();

  void _handleIngredientTap(int index) {
    final bool isSelected = _selectedIndices.contains(index);
    final ingredient = widget.ingredients[index];

    setState(() {
      if (isSelected) {
        _selectedIndices.remove(index);
        // Call the deselected callback
        widget.onIngredientDeselected(ingredient);
      } else {
        _selectedIndices.add(index);
        // Call the selected callback
        widget.onIngredientSelected(ingredient);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            title: Text(
              widget.title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            trailing: Icon(
              _isExpanded ? Icons.expand_less : Icons.expand_more,
            ),
          ),
          AnimatedCrossFade(
            firstChild: Container(),
            secondChild: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                childAspectRatio: 3.0,
              ),
              itemCount: widget.ingredients.length,
              itemBuilder: (context, index) {
                final ingredient = widget.ingredients[index];
                final bool isSelected = _selectedIndices.contains(index);
                return InkWell(
                  onTap: () => _handleIngredientTap(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.orange : Colors.blue[100],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        ingredient['name'],
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              },
            ),
            crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }
}
