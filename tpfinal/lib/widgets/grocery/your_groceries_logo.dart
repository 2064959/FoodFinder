import 'package:flutter/material.dart';

class YourGroceriesLogo extends StatelessWidget {
  const YourGroceriesLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/Your_Grocery.gif"),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );
  }
}
