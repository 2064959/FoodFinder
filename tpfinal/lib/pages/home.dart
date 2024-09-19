import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:tpfinal/pages/qr_scanner_page.dart';
import 'package:tpfinal/pages/welcome.dart';
import 'package:tpfinal/widgets/home/home_logo.dart';
import 'package:tpfinal/widgets/home/popular_product_list.dart';
import 'package:tpfinal/widgets/home/home_title.dart';

class Home extends StatelessWidget {
  final NotchBottomBarController? controller;
  const Home({super.key, this.controller});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: const [
          HomeLogo(),
          HomeTitle("Popular items", QRScannerPage()),
          Center(
            child: SizedBox(
              height: 215,
              child: PopularProductList(),
            ),
          ),
          HomeTitle("Latest items", Page2()),
          Center(child: Text('Items')),
        ],
      ),
    );
  }
}
