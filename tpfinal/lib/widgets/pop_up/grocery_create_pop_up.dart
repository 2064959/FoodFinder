import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tpfinal/model/grocery.dart';
import 'package:tpfinal/model/item.dart';
import 'package:tpfinal/pages/add_items.dart';
import 'package:tpfinal/util/dash_line.dart';
import 'package:tpfinal/widgets/openFood/open_food_item_simple.dart';
import 'package:tpfinal/widgets/items/item.dart';
import 'package:tpfinal/widgets/loading.dart';

class GroceryCreatePopUp extends StatefulWidget {
  const GroceryCreatePopUp({
    super.key,
  });

  @override
  State<GroceryCreatePopUp> createState() => _GroceryCreatePopUpState();
}

class _GroceryCreatePopUpState extends State<GroceryCreatePopUp> {
  Grocery item = Grocery("","", "", "noIcon.png", []);
  final List<String> items = [
    'icon_1.png',
    'icon_2.png',
    'icon_3.png',
    'icon_4.png',
    'icon_5.png',
    'icon_6.png',
    'icon_7.png',
    'icon_8.png',
    'icon_9.png',
    'icon_10.png',
    'icon_11.png',
    'icon_12.png',
    'icon_13.png',
    'icon_14.png',
  ];
  String selectedValue = "noIcon.png";
  bool hide = true;
  bool isEmpty = true;

  void addItem(String id) {
    setState(() {
      item.addItem(ObjectItem(id, 0, "noDone"));
      isEmpty = false;
    });
  }

  void empty() {
    setState(() {
      isEmpty = item.items!.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color.fromARGB(255, 246, 167, 197),
      child: Builder(
        builder: (context) {
          var width = MediaQuery.of(context).size.width;
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            width: width,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                              width: width / 2 - 40,
                              margin: const EdgeInsets.only(
                                top: 20,
                              ),
                              alignment: Alignment.topCenter,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    hide = !hide;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 40),
                                  child: Image.asset(
                                    selectedValue == "noIcon.png"
                                        ? 'assets/images/icons/addIcon.png'
                                        : 'assets/images/icons/$selectedValue',
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                  ),
                                ),
                              )),
                          Container(
                            width: width / 2 - 40,
                            margin: const EdgeInsets.only(
                              top: 20,
                            ),
                            alignment: Alignment.topLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Name",
                                    style: TextStyle(
                                      fontSize: width * 0.05,
                                      fontWeight: FontWeight.w500,
                                    )),
                                Container(
                                  margin:
                                      const EdgeInsets.only(top: 5, right: 20),
                                  child: TextField(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                      hintText: 'Enter a name',
                                    ),
                                    onChanged: (text) {
                                      setState(() {
                                        item.setName(text);
                                      });
                                      if (kDebugMode) {
                                        print("name changed to ${item.name}");
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      !hide ? listIcon() : Container(),
                      Container(
                        margin: const EdgeInsets.only(top: 20, bottom: 20),
                        alignment: Alignment.topCenter,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(
                                MediaQuery.of(context).size.width * 0.6,
                                MediaQuery.of(context).size.height * 0.07),
                            backgroundColor: const Color.fromARGB(255, 255, 205, 41),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, AddItems.routeName,
                                arguments: addItem);
                          },
                          child: Text("Add item",
                              style: TextStyle(
                                  color: Colors.black, fontSize: width * 0.05)),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        alignment: Alignment.topCenter,
                        child: const MySeparator(
                          color: Colors.black,
                          height: 2,
                        ),
                      ),
                      listItems(width),
                      isEmpty || item.name == ""
                          ? Container()
                          : Container(
                              margin:
                                  const EdgeInsets.only(left: 20, bottom: 40),
                              alignment: Alignment.bottomLeft,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(
                                      MediaQuery.of(context).size.width * 0.14,
                                      MediaQuery.of(context).size.height *
                                          0.07),
                                  backgroundColor:
                                      const Color.fromARGB(255, 255, 205, 41),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32.0),
                                  ),
                                ),
                                onPressed: () {
                                  addGrocery(item);
                                  Navigator.pop(context);
                                },
                                child: Text("+",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: width * 0.05)),
                              ),
                            )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Container listIcon() {
    return Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        alignment: Alignment.topCenter,
        child: GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 5,
          children: items
              .map((e) => Container(
                    margin: const EdgeInsets.all(5),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          item.setIcon(e);
                          selectedValue = e;
                          hide = !hide;
                        });
                        if (kDebugMode) {
                          print(item.icon);
                        }
                      },
                      child: Image.asset('assets/images/icons/$e'),
                    ),
                  ))
              .toList(),
        ));
  }

  Container listItems(double width) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 40),
      alignment: Alignment.topCenter,
      child: isEmpty
          ? Center(
              child: Text(
              "Empty",
              style: TextStyle(fontSize: width * 0.05),
            ))
          : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: item.items!.length,
              itemBuilder: (context, index) {
                final itemId = item.items![index].id;
                return Center(
                  child: FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection("globalListItem")
                        .doc(itemId)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        if (!snapshot.data!.exists) {
                          return futurBulderOpenFood(itemId);
                        }
                      }
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
                        child: Dismissible(
                          key: ValueKey(itemId),
                          background: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: MediaQuery.of(context).size.height *
                                      0.085,
                                  alignment: Alignment.centerLeft,
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
                              item.removeItemById(itemId);
                              empty();
                              return true;
                            }
                            return false;
                          },
                          onDismissed: (direction) {},
                          child: Item(
                            item: snapshot.data,
                            detail: true,
                            pop_up: null,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
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
            child: Dismissible(
                key: ValueKey(itemId),
                background: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.085,
                        alignment: Alignment.centerLeft,
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
                    item.removeItemById(itemId);
                    empty();
                    return true;
                  }
                  return false;
                },
                onDismissed: (direction) {},
                child:
                    OpenFoodItemSimple(context: context, snapshot: snapshot)),
          );
        });
  }

  addGrocery(Grocery grocery) async {
    String username = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get()
        .then((value) => value.docs[0].data()["username"]);

    await FirebaseFirestore.instance.collection("epiceries").add({
      "name": grocery.name,
      "createBy": username,
      "icon": grocery.icon,
      "items": [
        for (int i = 0; i < grocery.items!.length; i++)
          {
            "id": grocery.items![i].id,
            "quantity": grocery.items![i].quantity,
            "status": grocery.items![i].status,
          }
      ],
    }).then((value) {
      FirebaseFirestore.instance
          .collection("familles")
          .doc(value.id)
          .collection("membres")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({"id": FirebaseAuth.instance.currentUser!.uid});
      FirebaseFirestore.instance.collection("epicerieID").add({"id": value.id});
    });
    if (kDebugMode) {
      print("done");
    }
  }
}
