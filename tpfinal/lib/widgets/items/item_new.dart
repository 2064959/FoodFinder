import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class ItemNew extends StatelessWidget {
  const ItemNew({
    super.key,
    required this.item,
    required this.action,
  });

  final dynamic item;
  final Enum action;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Product>(
      future: null,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          Product product = snapshot.data!;
          Product? result = product;
          if (kDebugMode) {
            print(result);
          }
           
          return Container(
            margin: const EdgeInsets.only(top: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  result.productName ?? 'No name',
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    
                  },
                  child: const Text(
                    "View",
                    style: TextStyle(
                      color: Color(0xFF00AD48),
                      fontSize: 15,
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          return const Text('No data');
        }
      },
    );
  }

  Future<SearchResult> _fetchProduct() async {
    ProductSearchQueryConfiguration configuration =
      ProductSearchQueryConfiguration(
        parametersList: <Parameter>[
          const SortBy(option: SortOption.POPULARITY),
          const PageSize(size: 8),
        ], version: ProductQueryVersion.v3,
      );

      SearchResult result = await OpenFoodAPIClient.searchProducts(
        const User(userId: '', password: ''),
        configuration,
      );

      print(result.products?[0].productName);
      return result;
  }
    
}
