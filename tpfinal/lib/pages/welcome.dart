import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tpfinal/model/grocery.dart';
import 'package:tpfinal/pages/home.dart';
import 'package:tpfinal/pages/items.dart';
import 'package:tpfinal/pages/your_goceries.dart';
import 'package:tpfinal/widgets/home/sign_out.dart';
import 'package:tpfinal/widgets/pop_up/pop_up.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  var _vueCourrante = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        centerTitle: true,
        title: (_vueCourrante == 0)
            ? Text('Home',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.05))
            : (_vueCourrante == 1)
                ? Text('Your Goceries',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.05))
                : Text('Items',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.05)),
        actions: (_vueCourrante == 0)
            ? const [SignOut()]
            : (_vueCourrante == 1)
                ? const [
                    TextButton(
                        onPressed: null,
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ))
                  ]
                : null,
      ),
      body: (_vueCourrante == 0)
          ? const Home()
          : (_vueCourrante == 1)
              ? const YourGoceries()
              : const Items(),
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
      floatingActionButton: (_vueCourrante == 0)
          ? null
          : (_vueCourrante == 1)
              ? FloatingActionButton(
                  backgroundColor: const Color.fromARGB(255, 246, 167, 197),
                  elevation: 10,
                  heroTag: 'AddGrocery',
                  onPressed: () {
                    showDataAlert(context, null, "createGrocery", null,null);
                  },
                  child: const Icon(
                    Icons.add,
                    color: Color.fromARGB(255, 252, 223, 118),
                  ),
                )
              : FloatingActionButton(
                  backgroundColor: const Color.fromARGB(255, 246, 167, 197),
                  elevation: 10,
                  heroTag: 'createItem',
                  onPressed: () {
                    showDataAlert(context, null, "createItem", null,null);
                  },
                  child: const Icon(
                    Icons.add,
                    color: Color.fromARGB(255, 252, 223, 118),
                  ),
                ),
    );
  }

  List<BottomNavigationBarItem> get listItemNavigationBar {
    return <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: (_vueCourrante == 0)
            ? Image.asset(
                "assets/images/epicerie-fine.png",
                width: MediaQuery.of(context).size.width * 0.1,
                height: MediaQuery.of(context).size.height * 0.05,
              )
            : Image.asset(
                "assets/images/epicerie-fine-modified.png",
                width: MediaQuery.of(context).size.width * 0.1,
                height: MediaQuery.of(context).size.height * 0.05,
              ),
        label: "Home",
      ),
      BottomNavigationBarItem(
        icon: (_vueCourrante == 1)
            ? Image.asset(
                "assets/images/epicerie (1).png",
                width: MediaQuery.of(context).size.width * 0.1,
                height: MediaQuery.of(context).size.height * 0.05,
              )
            : Image.asset(
                "assets/images/epicerie (1)-modified.png",
                width: MediaQuery.of(context).size.width * 0.1,
                height: MediaQuery.of(context).size.height * 0.05,
              ),
        label: "Your Goceries",
      ),
      BottomNavigationBarItem(
        icon: (_vueCourrante == 2)
            ? Image.asset(
                "assets/images/epicerie.png",
                width: MediaQuery.of(context).size.width * 0.1,
                height: MediaQuery.of(context).size.height * 0.05,
              )
            : Image.asset(
                "assets/images/epicerie-modified.png",
                width: MediaQuery.of(context).size.width * 0.1,
                height: MediaQuery.of(context).size.height * 0.05,
              ),
        label: "Items",
      ),
    ];
  }
}
