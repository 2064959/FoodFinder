import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key, required this.onExitCallback, required this.product});
  final VoidCallback onExitCallback;
  final dynamic product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            onExitCallback(); // Correctly call the callback to resume scanning
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: Stack(
          children: [
            Column(
              children: [
                AspectRatio(
                  aspectRatio: 1.4,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: product.imageFrontUrl != null
                        ? Image.network(product.imageFrontUrl!)
                        : const Icon(Icons.image_not_supported),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 2,
                  decoration: BoxDecoration(
                    color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
                    borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                  ),
                )
              ],
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      children: [
                        Text('-   1   +'),
                        Text('Quantity'),
                      ],
                    ),
                    TextButton(
                      onPressed: () {}, 
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                        decoration: BoxDecoration(
                          color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text('Add to cart', style: TextStyle(color: Colors.white)),
                      ),
                    )
                  ],
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
