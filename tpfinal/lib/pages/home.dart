import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tpfinal/widgets/home/home_info.dart';
import 'package:tpfinal/widgets/home/home_logo.dart';
import 'package:tpfinal/widgets/items/item_list.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        HomeLogo(),
        HomeInfo(),
        LatestItems(),
        ItemsList(
          5,
          false,
          pop_up: true,
          additem: null,
        ),
      ],
    );
  }
}

class LatestItems extends StatelessWidget {
  const LatestItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, top: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Latest item added",
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.06,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
