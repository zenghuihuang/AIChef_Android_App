import 'dart:io';
import 'package:flutter/material.dart';
import '../models/ingredient.dart';
import '../utils/database.dart';

class FoodDetailsScreen extends StatelessWidget {
  final File imageFile;
  final String foodItemName;

  const FoodDetailsScreen({super.key, required this.imageFile, required this.foodItemName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Details'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.file(imageFile, width: double.infinity, height: 300, fit: BoxFit.cover),
          const SizedBox(height: 20),
          Text('Identified: $foodItemName', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async{
              // Add the identified item to the list of ingredients
              Ingredient newIngredient = Ingredient(name: foodItemName, amount: 1, bestBeforeDate: DateTime.now());
              await DatabaseHelper.instance.insertIngredient(newIngredient.toMap());

              // Show a notification that the item has been added
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$foodItemName added to ingredients list'),
                ),
              );
            },
            child: const Text('Add to list of ingredients'),
          ),
        ],
      ),
    );
  }
}
