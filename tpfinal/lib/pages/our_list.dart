import 'package:flutter/material.dart';
import 'package:tpfinal/widgets/items/item_list.dart';
import 'package:tpfinal/widgets/our_list_logo.dart';

class OurList extends StatelessWidget {
  final dynamic additem;
  const OurList({
    super.key,
    required this.additem,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children:  [
        const OurListLogo(),
        ItemsList(
          0,
          true,
          pop_up: false,
          additem: additem,
        ),
      ],
    );
  }
}
