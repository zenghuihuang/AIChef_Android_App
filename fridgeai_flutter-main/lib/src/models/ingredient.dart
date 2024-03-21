class Ingredient {
  int? id; // auto-incrementing primary key
  String name;
  int amount;
  DateTime bestBeforeDate;
  bool isSelected = false; // Optional: For tracking selection in UI


  Ingredient({
    this.id,
    required this.name,
    this.amount = 1,
    required this.bestBeforeDate,
  });
  // Convert an Ingredient object into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'bestBeforeDate': bestBeforeDate.toIso8601String(), // Store date as String
    };
  }

  static Ingredient fromMap(Map<String, dynamic> map) {
    return Ingredient(
      id: map['id'],
      name: map['name'],
      amount: map['amount'],
      bestBeforeDate: DateTime.parse(map['bestBeforeDate']),
    );
  }

}