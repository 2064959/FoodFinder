import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:tpfinal/pages/product_detail_page.dart';
import 'package:tpfinal/repositories/product_repository.dart';
import 'package:tpfinal/util/app_constants.dart';
import 'package:tpfinal/util/create_route.dart';
import 'package:tpfinal/widgets/home/product_card.dart';
import 'package:tpfinal/widgets/common/shimmer_loading.dart';

class PopularProductList extends StatefulWidget {
  final String? heroPrefix;
  const PopularProductList({super.key, this.heroPrefix});

  @override
  State<PopularProductList> createState() => _PopularProductListState();
}

class _PopularProductListState extends State<PopularProductList> {
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = ProductRepository().fetchPopularProducts(AppConstants.popularProductsLimit);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.65,
              ),
              itemCount: 4,
              itemBuilder: (context, index) => const ProductCardShimmer(),
            );
          } else if (snapshot.hasError || (snapshot.hasData && snapshot.data!.isEmpty)) {
            return const Center(
              child: Text(
                'Popular items currently unavailable',
                style: TextStyle(color: AppConstants.mediumGrey),
              ),
            );
          } else if (snapshot.hasData) {
            final List<Product> items = snapshot.data!;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.65, // Adjust for ProductCard height
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final String heroTag = widget.heroPrefix != null 
                    ? '${widget.heroPrefix}_${items[index].barcode}' 
                    : 'product_image_${items[index].barcode}';
                return ProductCard(
                  product: items[index], 
                  heroTag: heroTag,
                  onPress: () => Navigator.of(context).push(
                    createRouteToItemDetail(
                      ProductDetailPage(
                        onExitCallback: () {}, 
                        product: items[index],
                        heroTag: heroTag,
                      )
                    )
                  )
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

