import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tpfinal/main.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:tpfinal/util/app_constants.dart';
import 'package:tpfinal/util/like_service.dart';
import 'package:tpfinal/widgets/common/shimmer_loading.dart';

class ProductCard extends StatefulWidget {
  final double width, aspectRatio;
  final Product product;
  final VoidCallback onPress;
  final String? heroTag;
  final bool isChecked;
  final VoidCallback? onCheck;
  final VoidCallback? onDelete;

  const ProductCard({
    super.key,
    this.width = AppConstants.productCardWidth,
    this.aspectRatio = AppConstants.productCardAspectRatio,
    required this.product,
    required this.onPress,
    this.heroTag,
    this.isChecked = false,
    this.onCheck,
    this.onDelete,
  });

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> with SingleTickerProviderStateMixin {
  bool _isLiked = false;
  bool _isLoadingLike = true;
  late String connectedUserUid;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    connectedUserUid = Provider.of<AppState>(context, listen: false).connectedUserUid;
    _checkIfLiked();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
    return ScaleTransition(
      scale: _scaleAnimation,
      child: SizedBox(
        width: widget.width,
        child: GestureDetector(
          onTapDown: (_) => _animationController.forward(),
          onTapUp: (_) {
            _animationController.reverse();
            widget.onPress();
          },
          onTapCancel: () => _animationController.reverse(),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: widget.isChecked ? AppConstants.secondaryGreen.withOpacity(0.1) : Colors.white,
              border: Border.all(color: widget.isChecked ? AppConstants.primaryGreen : AppConstants.lightGrey),
              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                if (widget.onDelete != null)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: GestureDetector(
                      onTap: widget.onDelete,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppConstants.lightGrey),
                        ),
                        child: const Icon(Icons.close, size: 14, color: AppConstants.mediumGrey),
                      ),
                    ),
                  ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AspectRatio(
                      aspectRatio: widget.aspectRatio,
                      child: Hero(
                        tag: widget.heroTag ?? 'product_image_${widget.product.barcode}',
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          child: Opacity(
                            opacity: widget.isChecked ? 0.6 : 1.0,
                            child: (widget.product.imageFrontSmallUrl != null && 
                                    widget.product.imageFrontSmallUrl!.isNotEmpty)
                                ? CachedNetworkImage(
                                    imageUrl: widget.product.imageFrontSmallUrl!,
                                    fit: BoxFit.contain,
                                    placeholder: (context, url) => ShimmerLoading(
                                      child: Container(color: Colors.white),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.broken_image, color: Colors.grey),
                                  )
                                : (widget.product.imageFrontUrl != null && 
                                    widget.product.imageFrontUrl!.isNotEmpty)
                                ? CachedNetworkImage(
                                    imageUrl: widget.product.imageFrontUrl!,
                                    fit: BoxFit.contain,
                                    placeholder: (context, url) => ShimmerLoading(
                                      child: Container(color: Colors.white),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.broken_image, color: Colors.grey),
                                  )
                                : Image.asset(
                                    AppConstants.placeholderImage,
                                    fit: BoxFit.contain,
                                  ),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      widget.product.getBestProductName(OpenFoodFactsLanguage.ENGLISH),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        decoration: widget.isChecked ? TextDecoration.lineThrough : null,
                        color: widget.isChecked ? AppConstants.mediumGrey : null,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.product.getFirstBrand() ?? 'Unknown Brand',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppConstants.primaryOrange,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (widget.onCheck != null)
                          InkWell(
                            onTap: widget.onCheck,
                            child: Icon(
                              widget.isChecked ? Icons.check_circle : Icons.radio_button_unchecked,
                              color: widget.isChecked ? AppConstants.primaryGreen : AppConstants.mediumGrey,
                              size: 28,
                            ),
                          )
                        else
                          _isLoadingLike
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                              : InkWell(
                                  borderRadius: BorderRadius.circular(50),
                                  onTap: _toggleLike,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    height: 28,
                                    width: 28,
                                    decoration: BoxDecoration(
                                      color: _isLiked 
                                          ? AppConstants.primaryOrange.withOpacity(0.15)
                                          : AppConstants.mediumGrey.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: SvgPicture.string(
                                      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512"><path d="M47.6 300.4L228.3 469.1c7.5 7 17.4 10.9 27.7 10.9s20.2-3.9 27.7-10.9L464.4 300.4c30.4-28.3 47.6-68 47.6-109.5v-5.8c0-69.9-50.5-129.5-119.4-141C347 36.5 300.6 51.4 268 84L256 96 244 84c-32.6-32.6-79-47.5-124.6-39.9C50.5 55.6 0 115.2 0 185.1v5.8c0 41.5 17.2 81.2 47.6 109.5z"/></svg>',
                                      colorFilter: ColorFilter.mode(
                                          _isLiked ? AppConstants.highlightOrange : AppConstants.lightGrey,
                                          BlendMode.srcIn),
                                    ),
                                  ),
                                ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
