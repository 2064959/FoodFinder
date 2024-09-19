// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tpfinal/model/grocery.dart';
import 'package:tpfinal/model/item.dart';
import 'package:tpfinal/widgets/items/item.dart';
import 'package:tpfinal/widgets/loading.dart';
import 'package:tpfinal/widgets/openFood/open_food_item_simple.dart';

class GroceryItemsList extends StatelessWidget {
  const GroceryItemsList({
    super.key,
    required this.refresh,
    required this.item,
    required this.pop_up,
  });
  final VoidCallback refresh;
  final Grocery item;
  final bool pop_up;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          FirebaseFirestore.instance.collection("epiceries").doc(item.id).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text("Houston!!?"));
        } else if (!snapshot.hasData) {
          return const Center(child: Text("No data"));
        }

        final myItems = snapshot.data!["items"];
        final List listItem = myItems
            .map((e) => ObjectItem(e["id"], e["quantity"], e["status"]))
            .toList();
        if (kDebugMode) {
          print(listItem);
        }
        return ListView.builder(
            shrinkWrap: true,
            itemCount: myItems.length,
            itemBuilder: (context, index) {
              final itemId = myItems[index]["id"];
              return Center(
                child: FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection("globalListItem")
                      .doc(itemId)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: Container(
                              margin: EdgeInsets.all(
                                  MediaQuery.of(context).size.width * 0.08),
                              child: CircularProgressIndicator(
                                color: const Color.fromARGB(255, 151, 71, 255),
                                strokeWidth:
                                    MediaQuery.of(context).size.width * 0.02,
                              )));
                    } else if (!snapshot.hasData) {
                      return const Center(child: Text("Loading..."));
                    }
                    if (kDebugMode) {
                      print("data  ${snapshot.hasData}");
                    }
                    if (!snapshot.data!.exists) {
                      if (kDebugMode) {
                        print("data  ${snapshot.error}");
                      }
                      return futurBulderOpenFood(itemId);
                    }
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Dismissible(
                        key: ValueKey(itemId),
                        background: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.085,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                color: Colors.green,
                                child: const Icon(
                                  Icons.check,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.085,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                color: Colors.red,
                                child: const Icon(
                                  Icons.delete,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.startToEnd) {
                            if (listItem[index].status != "done") {
                              listItem[index].done("done");
                              FirebaseFirestore.instance
                                  .collection("epiceries")
                                  .doc(item.id)
                                  .update(
                                      {"items": convertItemsToMap(listItem)});
                              refresh();
                            }
                          }
                          if (direction == DismissDirection.endToStart) {
                            if (listItem[index].status != "notDone") {
                              listItem[index].done("notDone");
                              FirebaseFirestore.instance
                                  .collection("epiceries")
                                  .doc(item.id)
                                  .update(
                                      {"items": convertItemsToMap(listItem)});
                              refresh();
                            }
                          }
                          return false;
                        },
                        onDismissed: (direction) {},
                        child: Item(
                          item: snapshot.data,
                          detail: true,
                          pop_up: pop_up,
                        ),
                      ),
                    );
                  },
                ),
              );
            });
      },
    );
  }

  FutureBuilder<Article> futurBulderOpenFood(String itemId) {
    return FutureBuilder(
        future: load(itemId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading(context: context);
          } else if (!snapshot.hasData) {
            if (snapshot.hasError) {
              return const Center(child: Text("Houston!!?"));
            }
            return const Center(child: Text("Loading..."));
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: OpenFoodItemSimple(context: context, snapshot: snapshot),
          );
        });
  }
}
