import 'package:flutter/material.dart';

class HomeInfo extends StatelessWidget {
  const HomeInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      height: MediaQuery.of(context).size.height * 0.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(65),
        color: const Color.fromARGB(255, 255, 189, 108),
      ),
      child: Container(
        alignment: Alignment.center,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.1,
                  left: MediaQuery.of(context).size.width * 0.05),
              width: MediaQuery.of(context).size.width * 0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Grocery item",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.06,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RichText(
                      text: TextSpan(
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                          children: const [
                        TextSpan(
                            text:
                                "New Grocery item? If you can't find the item of"
                                "your choice in our global list. You can just add it in ",
                            style: TextStyle(
                              height: 1.5,
                            )),
                        TextSpan(
                          text: "item.",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                            height: 1.5,
                          ),
                        ),
                      ])),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/aliments.png',
                height: MediaQuery.of(context).size.height * 0.15,
                scale: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
