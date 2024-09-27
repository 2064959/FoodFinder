import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:tpfinal/database_helper.dart';
import 'package:tpfinal/pages/product_detail_page.dart';
import 'package:tpfinal/util/create_route.dart';
import 'package:tpfinal/widgets/home/product_card.dart';

class PopularProductList extends StatelessWidget {
  const PopularProductList({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<List<Product>>(
        future: DatabaseHelper().getPopularProducts(8),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            final List<Product> items = snapshot.data!;
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: ProductCard(
                    product: items[index], 
                    onPress: () => Navigator.of(context).push(
                      createRouteToItemDetail(
                        ProductDetailPage(
                          onExitCallback: () {}, 
                          product: items[index]
                        )
                      )
                    )
                  ),
                );
              },
            );
          } else {
            return const Text('No data');
          }
        },
      ),
    );
  }
}

