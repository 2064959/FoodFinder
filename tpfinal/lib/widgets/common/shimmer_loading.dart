import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tpfinal/util/app_constants.dart';

class ShimmerLoading extends StatelessWidget {
  final Widget child;
  const ShimmerLoading({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppConstants.shimmerBase,
      highlightColor: AppConstants.shimmerHighlight,
      child: child,
    );
  }
}

class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppConstants.productCardWidth,
      padding: const EdgeInsets.all(AppConstants.spacingMedium),
      decoration: BoxDecoration(
        color: AppConstants.white,
        border: Border.all(color: AppConstants.lightGrey),
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
      child: ShimmerLoading(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AspectRatio(
              aspectRatio: AppConstants.productCardAspectRatio,
              child: Container(
                decoration: BoxDecoration(
                  color: AppConstants.white,
                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                ),
              ),
            ),
            const SizedBox(height: AppConstants.spacingSmall),
            Container(
              height: 14,
              width: double.infinity,
              color: AppConstants.white,
            ),
            const SizedBox(height: AppConstants.spacingSmall),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 14,
                  width: 60,
                  color: AppConstants.white,
                ),
                Container(
                  height: 24,
                  width: 24,
                  decoration: const BoxDecoration(
                    color: AppConstants.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GroceryItemShimmer extends StatelessWidget {
  const GroceryItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, top: 20, right: 20),
      height: 70, // Fixed height for shimmer consistency
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppConstants.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
        border: Border.all(color: AppConstants.lightGrey),
      ),
      child: ShimmerLoading(
        child: Row(
          children: [
            const SizedBox(width: AppConstants.spacingSmall),
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: AppConstants.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppConstants.spacingMedium),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppConstants.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 60,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppConstants.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 30,
              height: 30,
              margin: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMedium),
              decoration: const BoxDecoration(
                color: AppConstants.white,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
