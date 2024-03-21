import '../models/shopping_item.dart';
class TrolleyService {
  static final TrolleyService _instance = TrolleyService._internal();

  factory TrolleyService() {
    return _instance;
  }

  TrolleyService._internal();

  final List<ShoppingItem> trolleyList = [];

  void addItemToTrolley(ShoppingItem item) {
    trolleyList.add(item);
  }

  void removeItemFromTrolley(String itemName) {
    trolleyList.removeWhere((item) => item.name == itemName);
  }

  List<ShoppingItem> getTrolleyItems() {
    return trolleyList;
  }
}
