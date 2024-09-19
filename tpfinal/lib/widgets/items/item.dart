import 'package:flutter/material.dart';
import 'package:tpfinal/widgets/pop_up/pop_up.dart';

class Item extends StatelessWidget {
  const Item({
    super.key,
    required this.item,
    required this.detail,
    required this.pop_up,
    this.additem,
  });

  final dynamic item;
  final bool detail;
  final bool? pop_up;
  final dynamic additem;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (pop_up != null) {
          if (pop_up!) {
            showDataAlert(context, item, "showItem", null,null);
          } else if (!pop_up!) {
            additem(item.id);
          }
        }
      },
      child: Container(
        margin: !detail
            ? const EdgeInsets.only(left: 20, top: 20, right: 100)
            : const EdgeInsets.only(),
        width: !detail
            ? MediaQuery.of(context).size.width * 0.55
            : MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.085,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: const Color.fromARGB(255, 179, 179, 179),
        ),
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              alignment: Alignment.centerRight,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      !detail
                          ? "${item.data()["category"]}"
                          : "${item["category"]}",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.03,
                          fontWeight: FontWeight.bold),
                    ),
                  ]),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20),
              width: MediaQuery.of(context).size.width * 0.55,
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    !detail ? "${item.data()["name"]}" : "${item["name"]}",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.07,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Caveat',
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    !detail
                        ? "Add by ${item.data()["addBy"]}"
                        : "Add by ${item["addBy"]}",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.03,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
