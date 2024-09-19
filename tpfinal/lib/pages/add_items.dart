import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tpfinal/model/item.dart';
import 'package:tpfinal/pages/global_list.dart';
import 'package:tpfinal/pages/our_list.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:tpfinal/widgets/pop_up/pop_up.dart';

class AddItems extends StatefulWidget {
  const AddItems({super.key});
  static String routeName = "addItems";

  @override
  State<AddItems> createState() => _AddItemsState();
}

class _AddItemsState extends State<AddItems> {
  String barCode = "";
  var _vueCourrante = 0;
  @override
  Widget build(BuildContext context) {
    final additem = ModalRoute.of(context)?.settings.arguments;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: null,
        actions: [
          (_vueCourrante == 1)
              ? IconButton(
                  icon: Image.asset("assets/images/camera.png"),
                  onPressed: () async {
                    String id = await scanQR();
                    Article item = await load(id);
                    if (item.id == "NotFound") {
                      // ignore: use_build_context_synchronously
                      showDataAlert(context, null, "NotFound", null, additem);
                      return;
                    }
                    bool isAlreadyIn = await FirebaseFirestore.instance
                        .collection("openfoodItemsID")
                        .where("id", isEqualTo: item.id)
                        .get()
                        .then((value) => value.docs.isNotEmpty);
                    if (isAlreadyIn) {
                      FirebaseFirestore.instance
                          .collection("openfoodItemsID")
                          .add({
                        'id': item.id,
                      });
                    }
                    // ignore: use_build_context_synchronously
                    showDataAlert(
                        // ignore: use_build_context_synchronously
                        context, item, "showOpenFoodItem", null, additem);
                  },
                )
              : const Center(),
        ],
      ),
      body: (_vueCourrante == 0)
          ? OurList(additem: additem)
          : GlobalList(additem: additem),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: MediaQuery.of(context).size.width * 0.03,
        unselectedFontSize: MediaQuery.of(context).size.width * 0.03,
        items: listItemNavigationBar,
        onTap: (index) {
          setState(() {
            _vueCourrante = index;
          });
        },
        currentIndex: _vueCourrante,
      ),
    );
  }

  List<BottomNavigationBarItem> get listItemNavigationBar {
    return <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: (_vueCourrante == 0)
            ? Image.asset(
                "assets/images/epicerie (9).png",
                width: MediaQuery.of(context).size.width * 0.1,
                height: MediaQuery.of(context).size.height * 0.05,
              )
            : Image.asset(
                "assets/images/epicerie (9)-modified.png",
                width: MediaQuery.of(context).size.width * 0.1,
                height: MediaQuery.of(context).size.height * 0.05,
              ),
        label: "Our List",
      ),
      BottomNavigationBarItem(
        icon: (_vueCourrante == 1)
            ? Image.asset(
                "assets/images/epicerie (8).png",
                width: MediaQuery.of(context).size.width * 0.1,
                height: MediaQuery.of(context).size.height * 0.05,
              )
            : Image.asset(
                "assets/images/epicerie (8)-modified.png",
                width: MediaQuery.of(context).size.width * 0.1,
                height: MediaQuery.of(context).size.height * 0.05,
              ),
        label: "Global List",
      ),
    ];
  }

  Future<String> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      if (kDebugMode) {
        print(barcodeScanRes);
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return "";

    return barcodeScanRes;
  }
}
