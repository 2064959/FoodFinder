import 'package:flutter/material.dart';
import 'package:tpfinal/widgets/add_to_grocery.dart';
import 'package:tpfinal/widgets/grocery/grocery_list.dart';

class AddToGrocery extends StatefulWidget {
  const AddToGrocery({super.key});
  static String routeName = "addToGrocery";

  @override
  State<AddToGrocery> createState() => _AddToGroceryState();
}

class _AddToGroceryState extends State<AddToGrocery> {
  @override
  Widget build(BuildContext context) {
    final itemId = ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: null,
        
      ),
      body: ListView(
        children: [
          const AddToGroceryLogo(),
          GroceryList(itemId, false),
        ],
      ),
    );
  }
}
