import 'package:flutter/material.dart';

class HomeLogo extends StatelessWidget {
  const HomeLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height * 0.3,
        padding: const EdgeInsets.only(top: 25),
        child: Image.asset(
          'assets/images/des-legumes.png',
          height: MediaQuery.of(context).size.height * 0.3,
          scale: 1.5,
        ),
      ),
      Container(
        height: MediaQuery.of(context).size.height * 0.3,
        
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromARGB(169, 252, 223, 118),
        ),
        margin: const EdgeInsets.all(20),
      ),
      Container(
        margin: const EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height * 0.3,
        alignment: Alignment.center,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Text(
            "A more easy grocery",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.12,
              fontFamily: 'Caveat',
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ]);
  }
}
