import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:provider/provider.dart';
import 'package:tpfinal/main.dart';
import 'package:tpfinal/util/app_constants.dart';
import 'package:tpfinal/util/like_service.dart';
import 'package:tpfinal/util/product_formatter.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({
    super.key,
    required this.onExitCallback,
    required this.product,
    this.heroTag,
  });
  final VoidCallback onExitCallback;
  final Product product;
  final String? heroTag;

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  bool _isLiked = false;
  bool _isLoadingLike = true;
  late String connectedUserUid;

  @override
  void initState() {
    super.initState();
    connectedUserUid = Provider.of<AppState>(context, listen: false).connectedUserUid;
    _checkIfLiked();
  }

  Future<void> _checkIfLiked() async {
    final bool isLiked = await LikeService.checkIfLiked(widget.product.barcode!, connectedUserUid);
    if (mounted) {
      setState(() {
        _isLiked = isLiked;
        _isLoadingLike = false;
      });
    }
  }

  Future<void> _toggleLike() async {
    final bool newStatus = await LikeService.toggleLike(
      context: context,
      product: widget.product,
      userUid: connectedUserUid,
      currentLikedStatus: _isLiked,
    );
    if (mounted) {
      setState(() {
        _isLiked = newStatus;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(
          widget.product.getBestProductName(OpenFoodFactsLanguage.ENGLISH),
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            widget.onExitCallback();
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: _isLoadingLike
                ? const SizedBox(width: 30, height: 30, child: CircularProgressIndicator(strokeWidth: 2))
                : InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: _toggleLike,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      height: 30,
                      width: 30,
                      child: SvgPicture.string(
                        '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512"><path d="M47.6 300.4L228.3 469.1c7.5 7 17.4 10.9 27.7 10.9s20.2-3.9 27.7-10.9L464.4 300.4c30.4-28.3 47.6-68 47.6-109.5v-5.8c0-69.9-50.5-129.5-119.4-141C347 36.5 300.6 51.4 268 84L256 96 244 84c-32.6-32.6-79-47.5-124.6-39.9C50.5 55.6 0 115.2 0 185.1v5.8c0 41.5 17.2 81.2 47.6 109.5z"/></svg>',
                        colorFilter: ColorFilter.mode(
                            _isLiked ? AppConstants.highlightOrange : AppConstants.lightGrey,
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
                  _ProductImageSection(product: widget.product, heroTag: widget.heroTag),
                  _ProductInfoSection(product: widget.product),
                  const SizedBox(height: 100), // Spacing for bottom bar
                ],
              ),
            ),
            const _BottomActionBar(),
          ],
        ),
      ),
    );
  }
}

class _ProductImageSection extends StatelessWidget {
  final Product product;
  final String? heroTag;
  const _ProductImageSection({required this.product, this.heroTag});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: AppConstants.productDetailImageAspectRatio,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Hero(
          tag: heroTag ?? 'product_image_${product.barcode}',
          child: (product.imageFrontUrl != null && product.imageFrontUrl!.isNotEmpty)
              ? CachedNetworkImage(
                  imageUrl: product.imageFrontUrl!,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => (product.imageFrontSmallUrl != null && 
                          product.imageFrontSmallUrl!.isNotEmpty)
                      ? CachedNetworkImage(
                          imageUrl: product.imageFrontSmallUrl!,
                          fit: BoxFit.contain,
                        )
                      : const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.broken_image, size: 60, color: Colors.grey),
                )
              : (product.imageFrontSmallUrl != null && product.imageFrontSmallUrl!.isNotEmpty)
                  ? CachedNetworkImage(
                      imageUrl: product.imageFrontSmallUrl!,
                      fit: BoxFit.contain,
                    )
                  : const Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
        ),
      ),
    );
  }
}

class _ProductInfoSection extends StatelessWidget {
  final Product product;
  const _ProductInfoSection({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height / 2),
      decoration: BoxDecoration(
        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppConstants.radiusLarge)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Nutrition facts", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _NutritionCardsRow(product: product),
            const SizedBox(height: 24),
            const Text("Details", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              ProductFormatter.getProductDescription(product),
              style: const TextStyle(fontSize: 16, color: AppConstants.darkGrey),
            ),
          ],
        ),
      ),
    );
  }
}

class _NutritionCardsRow extends StatelessWidget {
  final Product product;
  const _NutritionCardsRow({required this.product});

  @override
  Widget build(BuildContext context) {
    final String unitLabel = ProductFormatter.getPerUnitLabel(product);
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IngredientCard(
            title: "Sugar",
            quantity: unitLabel,
            percentage: ProductFormatter.getIngredientPercentage(product, Nutrient.sugars),
            color: const Color(0xFFE0F6FB),
          ),
          const SizedBox(width: 12),
          IngredientCard(
            title: "Salt",
            quantity: unitLabel,
            percentage: ProductFormatter.getIngredientPercentage(product, Nutrient.salt),
            color: const Color(0xFFFAE9F1),
          ),
          const SizedBox(width: 12),
          IngredientCard(
            title: "Fat",
            quantity: unitLabel,
            percentage: ProductFormatter.getIngredientPercentage(product, Nutrient.fat),
            color: const Color(0xFFFDF4E6),
          ),
          const SizedBox(width: 12),
          IngredientCard(
            title: "Energy",
            quantity: ProductFormatter.getEnergyKcal(product),
            percentage: ProductFormatter.getEnergyPercentage(product),
            color: const Color(0xFFFDEDF0),
          ),
        ],
      ),
    );
  }

}

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(AppConstants.radiusLarge)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('-   1   +', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Quantity', style: TextStyle(color: AppConstants.darkGrey)),
              ],
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusLarge)),
              ),
              child: const Text('Add to cart', style: TextStyle(color: Colors.white, fontSize: 16)),
            )
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

  const IngredientCard({
    super.key,
    required this.title,
    required this.quantity,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final double cardWidth = MediaQuery.of(context).size.width / 5.2;
    
    return Container(
      width: cardWidth,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          Text(quantity, style: const TextStyle(fontSize: 10, color: AppConstants.darkGrey), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Container(
            height: 50,
            width: 50,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: Center(
              child: Text(
                percentage,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
