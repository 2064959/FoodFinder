import 'package:flutter/material.dart';

class HomeLogo extends StatelessWidget {
  const HomeLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/EASYGROCERY_AN.gif"),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: null /* add child content here */,
      );
  }
}
