import 'package:flutter/material.dart';
import 'package:tpfinal/widgets/pop_up/grocery_create_pop_up.dart';
import 'package:tpfinal/widgets/pop_up/grocery_info_pop_up.dart';
import 'package:tpfinal/widgets/pop_up/item_create_pop_up.dart';
import 'package:tpfinal/widgets/pop_up/item_info_pop_up.dart';
import 'package:tpfinal/widgets/pop_up/not_found.dart';
import 'package:tpfinal/widgets/pop_up/open_food_item_pop_up.dart';

  showDataAlert(context, item, action, refresh, onclick) {
  showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) {
        if (action == "showItem") {
          return ItemInfoPopUp(
            item: item,
          );
        } else if (action == "showGrocery") {
          return GroceryInfoPopUp(
            item: item,
            refresh: refresh,
          );
        } else if (action == "createGrocery") {
          return const GroceryCreatePopUp();
        } else if (action == "createItem") {
          return const ItemCreatePopUp();
        } else if (action == "showOpenFoodItem") {
          return OpenFoodItemPopUp(
            item: item,
            onclick: onclick,
          );
        } else if (action =="NotFound") {
					return const NotFound();
				}
        return const Center();
      });
}


