import 'package:flutter/material.dart';
import 'package:tpfinal/util/create_route.dart';

class HomeTitle extends StatelessWidget {
  final String title;
  final dynamic page;

  const HomeTitle(this.title, this.page, {
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
              Navigator.of(context).push(createRoute(page));
            },
            child: Text(
              "View all",
              style: TextStyle(
                color: const Color(0xFF00AD48),
                fontSize: MediaQuery.of(context).size.width * 0.035,
              ),
            )
          )
        ],
      ),
    );
  }
}
