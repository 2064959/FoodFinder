import 'package:flutter/material.dart';

class NotFound extends StatelessWidget {
  const NotFound({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Builder(
        builder: (context) {
          var width = MediaQuery.of(context).size.width;

          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            child: const Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: Color.fromARGB(255, 207, 5, 5),
                shadowColor: Color.fromARGB(128, 179, 179, 179),
                child: Center(
                  child: Text("NOT FOUND!!!"),
                )),
          );
        },
      ),
    );
  }
}
