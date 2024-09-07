import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tpfinal/model/grocery.dart';
import 'package:tpfinal/model/item.dart';
import 'package:tpfinal/widgets/items/item.dart';
import 'package:tpfinal/widgets/loading.dart';
import 'package:tpfinal/widgets/openFood/open_food_item_simple.dart';

class ItemsList extends StatelessWidget {
  final int count;
  final bool fullList;
  final bool pop_up;
  final dynamic? additem;
  const ItemsList(
    this.count,
    this.fullList, {
    super.key,
    required this.pop_up,
    required this.additem,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("/globalListItem")
          .orderBy(
            "timestamp",
            descending: true,
          )
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading(context: context);
        }
        final myData = snapshot.data as QuerySnapshot<Map<String, dynamic>>;
        return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: fullList
                ? myData.docs.length
                : count >= myData.docs.length
                    ? myData.docs.length
                    : count,
            itemBuilder: (context, index) {
              if (myData.docs[index].data().containsKey("name")) {
                if (fullList) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Item(
                      item: myData.docs[index],
                      detail: fullList,
                      pop_up: pop_up,
                      additem: additem,
                    ),
                  );
                }
                return Item(
                    item: myData.docs[index], detail: false, pop_up: pop_up);
              }
              return const Text("Not a item");
            });
      },
    );
  }

  
}
