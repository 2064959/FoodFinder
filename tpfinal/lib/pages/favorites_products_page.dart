import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:provider/provider.dart';
import 'package:tpfinal/database_helper.dart';
import 'package:tpfinal/main.dart';
import 'package:tpfinal/pages/product_detail_page.dart';
import 'package:tpfinal/pages/qr_scanner_page.dart';
import 'package:tpfinal/util/create_route.dart';
import 'package:tpfinal/widgets/home/product_card.dart';

class PopularProductsPage extends StatelessWidget {
  const PopularProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    String connectedUserUid = Provider.of<AppState>(context, listen: false).connectedUserUid;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Favorites"),
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
            future: DatabaseHelper().getLikedProductsByUser(connectedUserUid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                final List<Product> items = snapshot.data!;
                final double aspectRatio = MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 1.5);
                return GridView.builder(
                  itemCount: items.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: aspectRatio,
                  ),
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: 215,
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
          )
        ),
      ),
    );
  }
}