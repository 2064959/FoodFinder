import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.08),
            child: CircularProgressIndicator(
              color: const Color.fromARGB(255, 151, 71, 255),
              strokeWidth: MediaQuery.of(context).size.width * 0.02,
            )));
  }
}