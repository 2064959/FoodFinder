import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:tpfinal/database_helper.dart';
import 'package:tpfinal/model/liked_products.dart';

class LikeService {
  static Future<bool> checkIfLiked(String barcode, String userUid) async {
    return await DatabaseHelper().isProductLikedByUser(barcode, userUid);
  }

  static Future<bool> toggleLike({
    required BuildContext context,
    required Product product,
    required String userUid,
    required bool currentLikedStatus,
  }) async {
    try {
      if (currentLikedStatus) {
        await DatabaseHelper().deleteLikedProduct(product.barcode!, userUid);
      } else {
        LikedProduct likedProduct = LikedProduct.fromProduct(product, userUid);
        await DatabaseHelper().insertLikedProduct(likedProduct);
      }
      return !currentLikedStatus;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('An error occurred while trying to update liked products.'),
        ));
      }
      return currentLikedStatus;
    }
  }
}
