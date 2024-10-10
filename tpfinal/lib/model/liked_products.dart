import 'dart:convert';

import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:tpfinal/model/item.dart';

class LikedProduct {
  final String idProduct;
  final String productName;
  final String brand;
  final String imageUrl;
  final Nutriments nutriments;
  final DateTime whenLiked;
  final String userUid;

  LikedProduct({required this.productName, required this.brand, required this.imageUrl, required this.idProduct, required this.whenLiked, required this.userUid, required this.nutriments});

  // Convert a LikedProduct into a Map. The keys must correspond to the column names.
  Map<String, dynamic> toMap() {
    return {
      'idProduct': idProduct,
      'whenLiked': whenLiked.toIso8601String(),
      'userUid': userUid,
      'productName': productName,
      'brands': brand,
      'imageFrontUrl': imageUrl,
      'nutriments': jsonEncode(nutriments.toJson()),
    };
  }

  // Extract a LikedProduct from a Map. The keys must correspond to the column names.
  factory LikedProduct.fromMap(Map<String, dynamic> map) {
    return LikedProduct(
      productName: map['productName'],
      brand: map['brand'],
      imageUrl: map['imageUrl'],
      idProduct: map['idProduct'],
      whenLiked: DateTime.parse(map['whenLiked']),
      userUid: map['userUid'],
      nutriments: Nutriments.fromJson(jsonDecode(map['nutriments'])),
    );
  }

  factory LikedProduct.fromProduct(Product product, String userUid,) {
    return LikedProduct(
      idProduct: product.barcode!,
      whenLiked: DateTime.now(),
      userUid: userUid,
      productName: product.productName!,
      brand: product.brands!,
      imageUrl: product.imageFrontUrl!,
      nutriments: product.nutriments!,
    );
  }
}
