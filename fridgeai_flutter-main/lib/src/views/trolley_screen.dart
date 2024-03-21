import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/shopping_item.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/TrolleyService.dart';



class TrolleyScreen extends StatefulWidget {
  const TrolleyScreen({super.key});

  @override
  _TrolleyScreenState createState() => _TrolleyScreenState();
}

class _TrolleyScreenState extends State<TrolleyScreen> {
  List<ShoppingItem> shoppingList = [
    // ShoppingItem(name: 'Tomatoes', quantity: 2),
    // ShoppingItem(name: 'Eggs', quantity: 12),
    // // Add more items as needed
  ];
  @override
  void initState() {
    super.initState();
    shoppingList = TrolleyService().getTrolleyItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trolley'),
      ),
      body: ListView.builder(
        itemCount: shoppingList.length,
        itemBuilder: (context, index) {
          final item = shoppingList[index];
          return Slidable(
            key: ValueKey(item.name),
            startActionPane: ActionPane(
              motion: const DrawerMotion(),
              children: [
                SlidableAction(
                  onPressed: (_) {
                    setState(() {
                      item.isBought = true;
                    });
                  },
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  icon: Icons.check,
                  label: 'Bought',
                ),
              ],
            ),
            endActionPane: ActionPane(
              motion: const DrawerMotion(),
              children: [
                SlidableAction(
                  onPressed: (_) {
                    setState(() {
                      shoppingList.removeAt(index);
                    });
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: ListTile(
              title: Text(
                item.name,
                style: TextStyle(
                  decoration: item.isBought ? TextDecoration.lineThrough : null,
                  color: item.isBought ? Colors.grey : null,
                ),
              ),
              leading: Checkbox(
                value: item.isBought,
                onChanged: (bool? value) {
                  setState(() => item.isBought = value!);
                },
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: item.isBought ? null : () => setState(() => item.quantity = (item.quantity > 1) ? item.quantity -1 : 1),
                  ),
                  Text('${item.quantity}'),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: item.isBought ? null : () => setState(() => item.quantity += 1),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addItemDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _addItemDialog() async {

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final String uid = user?.uid ?? "anonymous";

    // Reference to the user-specific shopping list in Firebase Realtime Database
    final dbRef = FirebaseDatabase.instance.ref("shoppingLists/$uid");
    TextEditingController itemNameController = TextEditingController();
    TextEditingController itemQuantityController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add new item'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: itemNameController,
                  decoration: const InputDecoration(hintText: "Item Name"),
                ),
                TextField(
                  controller: itemQuantityController,
                  decoration: const InputDecoration(hintText: "Quantity"),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () async {
                String itemName = itemNameController.text.trim();
                int itemQuantity = int.tryParse(itemQuantityController.text.trim()) ?? 0;

                if(itemName.isNotEmpty && itemQuantity > 0) {
                  // Add to Firebase Realtime Database
                  await dbRef.push().set({
                    "name": itemName,
                    "quantity": itemQuantity,
                    "isBought": false,
                  });


                  setState(() {
                    shoppingList.add(ShoppingItem(name: itemName, quantity: itemQuantity));
                  });

                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

}
