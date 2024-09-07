import 'package:flutter/material.dart';
import 'package:tpfinal/widgets/pop_up/pop_up.dart';

class OpenfoodItem extends StatelessWidget {
  const OpenfoodItem({
    super.key,
    required this.item,
    required this.detail,
    required this.popUp,
    this.additem,
  });

  final dynamic item;
  final bool detail;
  final bool? popUp;
  final dynamic? additem;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (popUp != null) {
          if (popUp!) {
            showDataAlert(context, item, "showOpenFoodItem", null, additem);
          } else if (!popUp!) {
            additem(item.id);
          }
        }
      },
      child: Container(
        width: !detail
            ? MediaQuery.of(context).size.width * 0.7
            : MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Color.fromARGB(0, 179, 179, 179),
        ),
        child: Card(
          color: Color.fromARGB(88, 179, 179, 179),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Image.network(item.image),
                  title: Text(
                    "Name of the product: ${item.nom}",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
