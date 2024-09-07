import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tpfinal/util/back_up_database.dart';
import 'package:tpfinal/widgets/grocery/grocery_list.dart';
import 'package:tpfinal/widgets/grocery/your_groceries_logo.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:tpfinal/widgets/items/item.dart';

class YourGoceries extends StatelessWidget {
  const YourGoceries({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final _database = Provider.of<MyGroceries>(context);
    return ListView(
      children: [
        const YourGroceriesLogo(),
        GroceryList(null, true),
      ],
    );
  }
}
