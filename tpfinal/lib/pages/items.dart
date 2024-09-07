import 'package:flutter/widgets.dart';
import 'package:tpfinal/widgets/items/item_list.dart';
import 'package:tpfinal/widgets/items/items_logo.dart';

class Items extends StatelessWidget {
  const Items({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children:  const [
        ItemsLogo(),
        ItemsList(0, true , pop_up: true, additem: null),
      ],
    );
  }
}
