import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:provider/provider.dart';
import 'package:tpfinal/database_helper.dart';
import 'package:tpfinal/main.dart';
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
        children:  [
          const HomeLogo(),
          const HomeTitle("Popular items", "/popularlatest_items"),
          Center(child: SizedBox(
            height: 150, 
            child: Center(
              child: FutureBuilder(
                future: DatabaseHelper().getPopularProducts(5),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final List<Product> items = snapshot.data as List<Product>;
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: items.length,

                      itemBuilder: (context, index) {
                        return Text(
                          items[index].productName ?? 'No name', 
                          style: const TextStyle(color: Colors.black),
                        );
                      }
                    );
                  } else {
                    return const Text('No data');
                  }
                }
              ),
            )
          ),),
          const HomeTitle("Latest items", "/latest_items"),
          const Center(child: Text('Items'),)
        ],
      ),
    );
  }
}
