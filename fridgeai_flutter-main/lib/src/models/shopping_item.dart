class ShoppingItem {
  String name;
  int quantity;
  bool isBought;

  ShoppingItem({required this.name, this.quantity = 1, this.isBought = false});

  // Map<String, dynamic> toJson() => {
  //   'name': name,
  //   'quantity': quantity,
  //   'isBought': isBought,
  // };
}
