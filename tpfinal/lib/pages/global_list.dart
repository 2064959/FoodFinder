import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tpfinal/model/grocery.dart';
import 'package:tpfinal/model/item.dart';
import 'package:tpfinal/widgets/global_list_logo.dart';
import 'package:tpfinal/widgets/openFood/open_food_item.dart';

class GlobalList extends StatelessWidget {
  final dynamic additem;
  const GlobalList({
    super.key,
    required this.additem,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const GlobalListLogo(),
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("openfoodItemsID")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text("Houston!!?"));
            } else if (!snapshot.hasData) {
              return const Center(child: Text("No data"));
            }

            final myData = snapshot.data as QuerySnapshot<Map<String, dynamic>>;

            return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: myData.docs.length,
                itemBuilder: (context, index) {
                  final id = myData.docs[index].data()["id"];
                  return Center(
                    child: FutureBuilder(
                        future: load(id),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child: Container(
                                    margin: EdgeInsets.all(
                                        MediaQuery.of(context).size.width *
                                            0.08),
                                    child: CircularProgressIndicator(
                                      color: const Color.fromARGB(
                                          255, 151, 71, 255),
                                      strokeWidth:
                                          MediaQuery.of(context).size.width *
                                              0.02,
                                    )));
                          } else if (!snapshot.hasData) {
                            if (snapshot.hasError) {
                              return const Center(child: Text("Houston!!?"));
                            }
                            return const Center(child: Text("Loading..."));
                          }
                          final openfoodItem = snapshot.data!;
                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: OpenfoodItem(
                              item: openfoodItem,
                              additem: additem,
                              detail: true,
                              popUp: true,
                            ),
                          );
                        }),
                  );
                });
          },
        ),
      ],
    );
  }
}
