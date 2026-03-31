import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:tpfinal/database_helper.dart';
import 'package:tpfinal/pages/product_detail_page.dart';
import 'package:tpfinal/pages/qr_scanner_page.dart';
import 'package:tpfinal/util/app_constants.dart';
import 'package:tpfinal/util/create_route.dart';
import 'package:tpfinal/widgets/home/product_card.dart';

class PopularProductsPage extends StatelessWidget {
  const PopularProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Popular items"),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner_outlined),
            onPressed: () {
              Navigator.of(context).push(createRoute(const QRScannerPage()));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FutureBuilder<List<Product>>(
            future: DatabaseHelper().getPopularProducts(AppConstants.popularProductsLimit),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                final List<Product> items = snapshot.data!;
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final double crossAxisSpacing = 10;
                    final double mainAxisSpacing = 10;
                    final int crossAxisCount = 2;
                    // Calculate aspect ratio based on expected card height (ProductCard + padding + text)
                    // Roughly card width / approx height
                    final double childAspectRatio = AppConstants.productCardAspectRatio * 0.8; 

                    return GridView.builder(
                      itemCount: items.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: crossAxisSpacing,
                        mainAxisSpacing: mainAxisSpacing,
                        childAspectRatio: childAspectRatio,
                      ),
                      itemBuilder: (context, index) {
                        return ProductCard(
                          product: items[index],
                          onPress: () => Navigator.of(context).push(
                            createRouteToItemDetail(
                              ProductDetailPage(
                                onExitCallback: () {},
                                product: items[index],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              } else {
                return const Center(child: Text('No popular products found.'));
              }
            },
          ),
        ),
      ),
    );
  }
}