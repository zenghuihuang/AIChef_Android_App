import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

import '../models/ingredient.dart';
import '../models/recipe.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('fridge_ai.db'); // Changed to a more general database name
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';

    // Create ingredients table
    await db.execute('''
CREATE TABLE ingredients (
  id $idType AUTOINCREMENT,
  name $textType,
  amount $integerType,
  bestBeforeDate $textType
)
''');

    // Create recipes table
    await db.execute('''
CREATE TABLE recipes (
  id INTEGER PRIMARY KEY,
  title TEXT,
  imageUrl TEXT,
  servings INTEGER,
  readyInMinutes INTEGER,
  ingredients TEXT,
  instructions TEXT,
  isLiked BOOLEAN NOT NULL
)
''');
  }

  // Insert or update a recipe
  Future<void> insertOrUpdateRecipe(Recipe recipe) async {
    final db = await instance.database;
    await db.insert(
      'recipes',
      recipe.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace, // This will update the recipe if it already exists
    );
  }

  // Fetch all liked recipes
  Future<List<Recipe>> getLikedRecipes() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'recipes',
      where: 'isLiked = ?',
      whereArgs: [1],
    );

    return maps.map((map) => Recipe.fromMap(map)).toList();
  }

  // Additional database helper methods...
  Future<int> insertIngredient(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('ingredients', row);
  }

  Future<List<Map<String, dynamic>>> getIngredients() async {
    final db = await instance.database;
    return await db.query('ingredients');
  }

  Future<int> updateIngredient(Map<String, dynamic> row) async {
    final db = await instance.database;
    int id = row['id'];
    return await db.update('ingredients', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteIngredient(int id) async {
    final db = await instance.database;
    return await db.delete('ingredients', where: 'id = ?', whereArgs: [id]);
  }
  Future<int> deleteIngredientByName(String name) async {
    final db = await instance.database;
    return await db.delete('ingredients', where: 'name = ?', whereArgs: [name]);
  }

  Future<List<Ingredient>> getIngredientsSortedByDate() async {
    final db = await instance.database;
    final result = await db.query(
      'ingredients', // Assuming your table is named 'ingredients'
      orderBy: 'bestBeforeDate ASC', // Sort by bestBeforeDate in ascending order
    );

    if (result.isNotEmpty) {
      return result.map((json) => Ingredient.fromMap(json)).toList();
    } else {
      return [];
    }
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
