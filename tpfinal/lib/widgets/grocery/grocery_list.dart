import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tpfinal/model/grocery.dart';
import 'package:tpfinal/widgets/grocery/grocery.dart';

class GroceryList extends StatefulWidget {
  GroceryList(this.item,this.pop_up,{
    super.key,
  });
  dynamic item;
  bool pop_up;

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  bool refresh = false;
  void refreshListGrocerie() {
    setState(() {
      refresh = !refresh;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("epicerieID").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return const SizedBox(width: 0, height: 0,);
        }

        final myData = snapshot.data as QuerySnapshot<Map<String, dynamic>>;

        return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: myData.docs.length,
            itemBuilder: (context, index) {
              final group = myData.docs[index].data()["id"];
              if (kDebugMode) {
                print(group);
              }
              print(refresh);
              return Center(
                child: FutureBuilder(
                    future: getGroceryByGroup(group),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: Container(
                                margin: EdgeInsets.all(
                                    MediaQuery.of(context).size.width * 0.08),
                                child: CircularProgressIndicator(
                                  color:
                                      const Color.fromARGB(255, 151, 71, 255),
                                  strokeWidth:
                                      MediaQuery.of(context).size.width * 0.02,
                                )));
                      } else if (!snapshot.hasData) {
                        return const SizedBox(width: 0, height: 0,);
                      }
                      final grocery = snapshot.data!;
                      return GroceryShow(
                        grocery: grocery,
                        refresh: refreshListGrocerie,
                        pop_up: widget.pop_up,
                        item: widget.item,
                      );
                    }),
              );
            });
      },
    );
  }
}
