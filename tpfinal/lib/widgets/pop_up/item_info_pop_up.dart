import 'package:flutter/material.dart';
import 'package:tpfinal/pages/add_to_grocery.dart';

class ItemInfoPopUp extends StatelessWidget {
  const ItemInfoPopUp({
    super.key,
    required this.item,
  });
  final dynamic item;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Builder(
        builder: (context) {
          var width = MediaQuery.of(context).size.width;

          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            width: width,
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/post-it-modified.png',
                  width: double.infinity,
                  height: 400,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20, left: 20),
                  alignment: Alignment.topLeft,
                  child: Text("${item.data()["name"]}",
                      style: const TextStyle(
                        fontSize: 60,
                        fontFamily: 'OoohBaby',
                        fontWeight: FontWeight.bold,
                      )),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 100, left: 20),
                  alignment: Alignment.topLeft,
                  child: Text("Add by ${item.data()["addBy"]}",
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                      )),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 45, right: 20),
                  alignment: Alignment.topRight,
                  child: Text("${item.data()["category"]}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      )),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 20, bottom: 20),
                  alignment: Alignment.bottomRight,
                  child: Image(
                    image: item.data()["image"] != null
                        ? NetworkImage(
                            item.data()["image"],
                          )
                        : const NetworkImage(
                            "https://firebasestorage.googleapis.com/v0/b/tpfinal-mobil.appspot.com/o/no-photo.png?alt=media&token=bcec8e74-1b42-431d-a7a0-8002102b7fe4",
                          ),
                    width: MediaQuery.of(context).size.width * 0.3,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, bottom: 20),
                  alignment: Alignment.bottomLeft,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 205, 41),
                      fixedSize: Size(MediaQuery.of(context).size.width * 0.25,
                          MediaQuery.of(context).size.height * 0.05),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, AddToGrocery.routeName,
                                arguments: item.id);
                    },
                    child: const Text("Add",
                        style: TextStyle(color: Colors.black)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
