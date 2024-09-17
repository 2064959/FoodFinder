import 'package:flutter/material.dart';

class HomeTitle extends StatelessWidget {
  final String title;
  final String path;

  const HomeTitle(this.title, this.path, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.06,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, path);
            },
            child: Text(
              "View all",
              style: TextStyle(
                color: Color(0xFF00AD48),
                fontSize: MediaQuery.of(context).size.width * 0.035,
              ),
            )
          )
        ],
      ),
    );
  }
}
