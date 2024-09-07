import 'package:flutter/material.dart';

class AddToGroceryLogo extends StatelessWidget {
  const AddToGroceryLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Stack(children: [
      Container(
        height: height * 0.3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromARGB(255, 252, 223, 118),
        ),
        margin: const EdgeInsets.only(top: 20, bottom: 20),
      ),
      Container(
        width: width * 0.6,
        margin: const EdgeInsets.only(left: 20),
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              height: height * 0.3,
              padding: const EdgeInsets.only(top: 30),
              child: Image.asset(
                'assets/images/bloc-notes (1).png',
                height: height * 0.5,
                scale: 1.5,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.065),
              height: height * 0.3,
              width: width * 0.4,
              alignment: Alignment.center,
              child: Text(
                "Pick your Grocery",
                style: TextStyle(
                  fontSize: width * 0.09,
                  fontFamily: 'Caveat',
                  color: Colors.black,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
      Container(
        width: width * 0.42,
        margin: EdgeInsets.only(left: width - width * 0.42),
        child: Stack(
          children: [
            Container(
              alignment: Alignment.topLeft,
              height: height * 0.07,
              margin: const EdgeInsets.only(top: 30),
              child: Image.asset(
                'assets/images/aliments.png',
                scale: 1.5,
              ),
            ),
            Container(
              alignment: Alignment.topRight,
              height: height * 0.07,
              margin: const EdgeInsets.only(top: 30),
              child: Image.asset(
                'assets/images/en-mangeant.png',
                scale: 1.5,
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              height: height * 0.07,
              margin: EdgeInsets.only(top: height * 0.3 - height * 0.07),
              child: Image.asset(
                'assets/images/manga.png',
                scale: 1.5,
              ),
            ),
            Container(
              alignment: Alignment.bottomRight,
              height: height * 0.07,
              margin: EdgeInsets.only(top: height * 0.3 - height * 0.07),
              child: Image.asset(
                'assets/images/en-mangeant (1).png',
                scale: 1.5,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              height: height * 0.3,
              width: width * 0.5,
              alignment: Alignment.center,
              child: Text(
                "Add an item in you personal or shared groceries",
                style: TextStyle(
                  fontSize: width * 0.05,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
