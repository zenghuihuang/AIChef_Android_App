// import 'package:test/test.dart';
// import '../../lib/src/models/shopping_item.dart';
// //Unit test for Shopping Item model
//
// void main() {
//   group('ShoppingItem toJson Tests', () {
//     test('toJson returns correct map with default values', () {
//       final item = ShoppingItem(name: 'Apples');
//       final json = item.toJson();
//
//       expect(json, isA<Map<String, dynamic>>());
//       expect(json['name'], 'Apples');
//       expect(json['quantity'], 1);
//       expect(json['isBought'], false);
//     });
//
//     test('toJson returns correct map with non-default quantity', () {
//       final item = ShoppingItem(name: 'Oranges', quantity: 3);
//       final json = item.toJson();
//
//       expect(json, isA<Map<String, dynamic>>());
//       expect(json['name'], 'Oranges');
//       expect(json['quantity'], 3);
//       expect(json['isBought'], false);
//     });
//
//     test('toJson returns correct map with bought status', () {
//       final item = ShoppingItem(name: 'Bananas', isBought: true);
//       final json = item.toJson();
//
//       expect(json, isA<Map<String, dynamic>>());
//       expect(json['name'], 'Bananas');
//       expect(json['quantity'], 1); // Default quantity
//       expect(json['isBought'], true);
//     });
//
//    //flutter test test/shopping_item_test.dart
//   });
// }
