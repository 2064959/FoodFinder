import 'package:flutter/material.dart';
import 'package:tpfinal/model/grocery.dart';
import 'package:tpfinal/util/dash_line.dart';
import 'package:tpfinal/widgets/pop_up/grocery_list_item.dart';

class GroceryInfoPopUp extends StatelessWidget {
  const GroceryInfoPopUp({
    super.key,
    required this.item,
    required this.refresh,
  });
  final Grocery item;
  final dynamic refresh;

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
                Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: width / 2 - 40,
                          margin: EdgeInsets.only(
                            top: 20,
                          ),
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: Image.asset(
                              'assets/images/icons/${item.icon}',
                              width: MediaQuery.of(context).size.width * 0.3,
                              scale: 1.5,
                            ),
                          ),
                        ),
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
                              Text("${item.name}",
                                  style: TextStyle(
                                    fontSize: width * 0.08,
                                    fontFamily: 'Caveat',
                                    fontWeight: FontWeight.w500,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 20),
                      alignment: Alignment.topCenter,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.6,
                              MediaQuery.of(context).size.height * 0.07),
                          backgroundColor: Color.fromARGB(255, 255, 205, 41),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                        ),
                        onPressed: () {},
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
                    Container(
                      height: MediaQuery.of(context).size.height * 0.35,
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      alignment: Alignment.topCenter,
                      child: GroceryItemsList(
                        item: item,
                        refresh: refresh,
                        pop_up: false,
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
