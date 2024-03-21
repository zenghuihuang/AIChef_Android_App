class Recipe {
  final int id;
  final String title;
  final String imageUrl;
  final int? servings;
  final int? readyInMinutes;
  final List<String>? ingredients;
  final String? summary;
  final List<String>? instructions;
  bool isLiked;

  Recipe({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.servings,
    this.readyInMinutes,
    this.ingredients,
    this.summary,
    this.instructions,
    this.isLiked = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'servings': servings,
      'readyInMinutes': readyInMinutes,
      'ingredients': ingredients?.join(','),
      'instructions': instructions?.join('||'),
      'isLiked': isLiked ? 1 : 0,
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    List<String>? ingredientsList = map['ingredients'] != null
        ? (map['ingredients'] as String).split(',').toList()
        : null;

    List<String>? instructionsList = map['instructions'] != null
        ? (map['instructions'] as String).split('||').toList()
        : null;

    return Recipe(
      id: map['id'],
      title: map['title'],
      imageUrl: map['imageUrl'],
      servings: map['servings'],
      readyInMinutes: map['readyInMinutes'],
      ingredients: ingredientsList,
      instructions: instructionsList,
      isLiked: map['isLiked'] == 1,
    );
  }

  factory Recipe.fromJson(Map<String, dynamic> json) {
    List<String>? ingredientsList = json['extendedIngredients'] != null
        ? List.from(json['extendedIngredients']).map((ingredient) => ingredient['name'].toString()).toList()
        : null;


    List<String>? instructionsList;
    if (json['analyzedInstructions'] != null && json['analyzedInstructions'].isNotEmpty) {
      instructionsList = [];
      json['analyzedInstructions'][0]['steps'].forEach((step) {
        instructionsList!.add(step['step'].toString());
      });
    }

    return Recipe(
      id: json['id'],
      title: json['title'],
      imageUrl: json['image'] ?? '',
      servings: json['servings'],
      readyInMinutes: json['readyInMinutes'],
      ingredients: ingredientsList,
      instructions: instructionsList,
      isLiked: false,
    );
  }
}
