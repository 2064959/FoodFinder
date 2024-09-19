import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tpfinal/database_helper.dart';
import 'package:tpfinal/model/liked_products.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class ProductCard extends StatefulWidget {
  final double width, aspectRatio;
  final Product product;
  final VoidCallback onPress;

  const ProductCard({
    super.key,
    this.width = 162,
    this.aspectRatio = 1.02,
    required this.product,
    required this.onPress,
  });

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _checkIfLiked();
  }

  Future<void> _checkIfLiked() async {
    bool isLiked = await DatabaseHelper().isProductLiked(widget.product.barcode!);
    if (mounted) {
      setState(() {
        _isLiked = isLiked;
      });
    }
  }

  Future<void> _toggleLike() async {
    if (_isLiked) {
      await DatabaseHelper().deleteLikedProduct(widget.product.barcode!);
    } else {
      LikedProduct likedProduct = LikedProduct.fromProduct(widget.product.barcode!);
      await DatabaseHelper().insertLikedProduct(likedProduct);
    }
    if (mounted) {
      setState(() {
        _isLiked = !_isLiked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: GestureDetector(
        onTap: widget.onPress,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFDBDEE4)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AspectRatio(
                aspectRatio: widget.aspectRatio,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: widget.product.imageFrontUrl != null
                      ? Image.network(widget.product.imageFrontUrl!)
                      : const Icon(Icons.image_not_supported),
                ),
              ),
              Text(
                widget.product.getBestProductName(OpenFoodFactsLanguage.ENGLISH),
                style: Theme.of(context).textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.product.getFirstBrand() ?? 'Unknown Brand',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFF7643),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: _toggleLike,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                        color: widget.product.nutritionData != null
                            ? const Color(0xFFFF7643).withOpacity(0.15)
                            : const Color(0xFF979797).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.string(
                        '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512"><!--!Font Awesome Free 6.6.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2024 Fonticons, Inc.--><path d="M47.6 300.4L228.3 469.1c7.5 7 17.4 10.9 27.7 10.9s20.2-3.9 27.7-10.9L464.4 300.4c30.4-28.3 47.6-68 47.6-109.5v-5.8c0-69.9-50.5-129.5-119.4-141C347 36.5 300.6 51.4 268 84L256 96 244 84c-32.6-32.6-79-47.5-124.6-39.9C50.5 55.6 0 115.2 0 185.1v5.8c0 41.5 17.2 81.2 47.6 109.5z"/></svg>',
                        colorFilter: ColorFilter.mode(
                            _isLiked ? const Color(0xFFFF4848) : const Color(0xFFDBDEE4),
                            BlendMode.srcIn),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
