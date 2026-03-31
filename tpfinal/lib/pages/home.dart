import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:tpfinal/pages/popular_products_page.dart';
import 'package:tpfinal/widgets/home/home_logo.dart';
import 'package:tpfinal/widgets/home/popular_product_list.dart';
import 'package:tpfinal/widgets/home/home_title.dart';
import 'package:tpfinal/util/app_constants.dart';

class Home extends StatelessWidget {
  final NotchBottomBarController? controller;
  const Home({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: AppConstants.spacingMedium),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: const [
          SizedBox(height: AppConstants.spacingMedium),
          HomeLogo(),
          SizedBox(height: AppConstants.spacingMedium),
          HomeTitle("Popular items", PopularProductsPage()),
          PopularProductList(heroPrefix: "popular"),
          SizedBox(height: AppConstants.spacingLarge),
          /*HomeTitle("Latest items", PopularProductsPage()),
          SizedBox(
            height: AppConstants.productCardHeight,
            child: PopularProductList(heroPrefix: "latest"), // Reuse list for now as placeholder
          ),
          SizedBox(height: AppConstants.spacingXLarge),*/
        ],
      ),
    );
  }
}
