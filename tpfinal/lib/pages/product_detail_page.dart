import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:provider/provider.dart';
import 'package:tpfinal/database_helper.dart';
import 'package:tpfinal/main.dart';
import 'package:tpfinal/model/liked_products.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage(
      {super.key, required this.onExitCallback, required this.product});
  final VoidCallback onExitCallback;
  final Product product;

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  bool _isLiked = false;
  late String connectedUserUid;

  @override
  void initState() {
    super.initState();
    connectedUserUid =
        Provider.of<AppState>(context, listen: false).connectedUserUid;
    _checkIfLiked();
  }

  Future<void> _checkIfLiked() async {
    bool isLiked = await DatabaseHelper()
        .isProductLikedByUser(widget.product.barcode!, connectedUserUid);
    if (mounted) {
      setState(() {
        _isLiked = isLiked;
      });
    }
  }

  Future<void> _toggleLike() async {
    try {
      if (_isLiked) {
        await DatabaseHelper()
            .deleteLikedProduct(widget.product.barcode!, connectedUserUid);
      } else {
        LikedProduct likedProduct =
            LikedProduct.fromProduct(widget.product, connectedUserUid);
        await DatabaseHelper().insertLikedProduct(likedProduct);
      }
      if (mounted) {
        setState(() {
          _isLiked = !_isLiked;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('An error occurred while trying to like this product.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(
            widget.product.getBestProductName(OpenFoodFactsLanguage.ENGLISH)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            widget
                .onExitCallback(); // Correctly call the callback to resume scanning
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: _toggleLike,
              child: Container(
                padding: const EdgeInsets.all(6),
                height: 30,
                width: 30,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.string(
                  '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512"><!--!Font Awesome Free 6.6.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2024 Fonticons, Inc.--><path d="M47.6 300.4L228.3 469.1c7.5 7 17.4 10.9 27.7 10.9s20.2-3.9 27.7-10.9L464.4 300.4c30.4-28.3 47.6-68 47.6-109.5v-5.8c0-69.9-50.5-129.5-119.4-141C347 36.5 300.6 51.4 268 84L256 96 244 84c-32.6-32.6-79-47.5-124.6-39.9C50.5 55.6 0 115.2 0 185.1v5.8c0 41.5 17.2 81.2 47.6 109.5z"/></svg>',
                  colorFilter: ColorFilter.mode(
                      _isLiked
                          ? const Color(0xFFFF4848)
                          : const Color(0xFFDBDEE4),
                      BlendMode.srcIn),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 1.4,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: widget.product.imageFrontUrl != null
                          ? Image.network(widget.product.imageFrontUrl!)
                          : const Icon(Icons.image_not_supported),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .bottomNavigationBarTheme
                          .backgroundColor,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Nutrition facts",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IngredientCard(
                                title: "Sugar",
                                quantity: "100 g",
                                percentage:
                                    "${(widget.product.nutriments!.getValue(Nutrient.sugars, PerSize.oneHundredGrams) ?? 0).toStringAsFixed(1)}%",
                                color: const Color(0xFFE0F6FB),
                              ),
                              const SizedBox(width: 16),
                              IngredientCard(
                                title: "Salt",
                                quantity: "100 g",
                                percentage:
                                    "${(widget.product.nutriments!.getValue(Nutrient.salt, PerSize.oneHundredGrams) ?? 0).toStringAsFixed(1)}%",
                                color: const Color(0xFFFAE9F1),
                              ),
                              const SizedBox(width: 16),
                              IngredientCard(
                                title: "Fat",
                                quantity: "100 g",
                                percentage:
                                    "${(widget.product.nutriments!.getValue(Nutrient.fat, PerSize.oneHundredGrams) ?? 0).toStringAsFixed(1)}%",
                                color: const Color(0xFFFDF4E6),
                              ),
                              const SizedBox(width: 16),
                              IngredientCard(
                                title: "Energy",
                                quantity:
                                    "${widget.product.nutriments!.getValue(Nutrient.energyKCal, PerSize.oneHundredGrams)?.round()} Kcal",
                                percentage:
                                    "${((widget.product.nutriments!.getValue(Nutrient.energyKJ, PerSize.oneHundredGrams) ?? 0) / (widget.product.nutriments!.getValue(Nutrient.energyKCal, PerSize.oneHundredGrams) ?? 1)).toStringAsFixed(1)}%",
                                color: const Color(0xFFFDEDF0),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            "Ingredients",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          GridView.builder(
                            physics:
                                NeverScrollableScrollPhysics(), // Prevent internal scrolling
                            shrinkWrap:
                                true, // Allows the GridView to adjust its height dynamically
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 150,
                              childAspectRatio: 3 / 2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                            ),
                            itemCount: widget.product.ingredients!.length,
                            itemBuilder: (ctx, index) {
                              return CategoryItem(
                                name: widget.product.ingredients![index].text ??
                                    'Unknown ingredient',
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 35, vertical: 15),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .bottomNavigationBarTheme
                                .selectedItemColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Text('Add to cart',
                              style: TextStyle(color: Colors.white)),
                        ),
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class IngredientCard extends StatelessWidget {
  final String title;
  final String quantity;
  final String percentage;
  final Color color;

  IngredientCard({
    required this.title,
    required this.quantity,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 5.4,
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            quantity,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 107, 107, 107)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Container(
            height: 60,
            width: 60,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
            ),
            child: Center(
              child: Text(
                percentage,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String name;

  CategoryItem({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.green,
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          name,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
