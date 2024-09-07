import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tpfinal/model/grocery.dart';
import 'package:tpfinal/widgets/pop_up/pop_up.dart';

class GroceryShow extends StatelessWidget {
  const GroceryShow({
    super.key,
    required this.grocery,
    required this.refresh,
    required this.pop_up,
    this.item,
  });

  final Grocery grocery;
  final VoidCallback refresh;
  final bool pop_up;
  final dynamic item;

  @override
  Widget build(BuildContext context) {
    var pourcentage =
        (grocery.items?.where((item) => item.stat == 'done').length ?? 0) *
            100 /
            (grocery.items?.length ?? 0);
    return InkWell(
      onTap: () {
        if (pop_up) {
          showDataAlert(context, grocery, "showGrocery", refresh, null);
          print("showGrocery");
        } else {
          if (grocery.items!
              .where((element) => element.id == item)
              .isNotEmpty) {
            grocery.items!
                .where((element) => element.id == item)
                .first
                .quantity++;
          } else {
            grocery.items!.add(ObjectItem(item, 1, "noDone"));
          }
          FirebaseFirestore.instance
              .collection("epiceries")
              .doc(grocery.id)
              .update({"items": convertItemsToMap(grocery.items!)});
          Navigator.pop(context);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(left: 20, top: 20, right: 20),
        height: MediaQuery.of(context).size.height * 0.085,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: const Color.fromARGB(255, 179, 179, 179),
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Stack(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 2),
                width: MediaQuery.of(context).size.width * 0.55,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/icons/${grocery.icon}',
                          height: MediaQuery.of(context).size.height * 0.075,
                          scale: 1.5,
                        ),
                        Flexible(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.55,
                            padding: const EdgeInsets.only(
                                top: 2, bottom: 5, left: 5),
                            height: MediaQuery.of(context).size.height * 0.08,
                            child: Stack(
                              children: [
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    grocery.name,
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.07,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Caveat',
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    "${grocery.items?.length} items",
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(right: 5),
                alignment: Alignment.centerRight,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        pourcentage == 100 ? "Done" : "$pourcentage%",
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                            fontWeight: FontWeight.w400),
                      ),
                      Image.asset(
                        pourcentage == 100
                            ? 'assets/images/done.png'
                            : 'assets/images/notDone.png',
                        height: MediaQuery.of(context).size.height * 0.075,
                        scale: 1.5,
                      ),
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
