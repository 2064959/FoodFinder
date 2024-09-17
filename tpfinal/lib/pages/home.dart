import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tpfinal/util/acton_enum.dart';
import 'package:tpfinal/widgets/home/home_info.dart';
import 'package:tpfinal/widgets/home_title.dart';
import 'package:tpfinal/widgets/home/home_logo.dart';
import 'package:tpfinal/widgets/items/item_list.dart';
import 'package:tpfinal/widgets/home_title.dart';
import 'package:tpfinal/widgets/items/item_new.dart';

class Home extends StatelessWidget {
  final NotchBottomBarController? controller;
  const Home({super.key, this.controller});
  

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: ListView(
        children:  const [
          HomeLogo(),
          HomeTitle("Popular items", "/popularlatest_items"),
          Center(child: SizedBox(height: 150, child: ItemNew(item: null, action: ItemActionEnum.ADD_FROM_HOME)),),
          HomeTitle("Latest items", "/latest_items"),
          Center(child: Text('Items'),)
        ],
      ),
    );
  }
}
