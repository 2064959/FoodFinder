class LikedProduct {
  final String idProduct;
  final String productName;
  final String brand;
  final String imageUrl;
  final DateTime whenLiked;
  final String userUid;

  LikedProduct({required this.productName, required this.brand, required this.imageUrl, required this.idProduct, required this.whenLiked, required this.userUid});

  // Convert a LikedProduct into a Map. The keys must correspond to the column names.
  Map<String, dynamic> toMap() {
    return {
      'idProduct': idProduct,
      'whenLiked': whenLiked.toIso8601String(),
      'userUid': userUid,
      'productName': productName,
      'brands': brand,
      'imageFrontUrl': imageUrl,
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
    );
  }

  factory LikedProduct.fromProduct(String idProduct, String userUid, String productName, String brand, String imageUrl) {
    return LikedProduct(
      idProduct: idProduct,
      whenLiked: DateTime.now(),
      userUid: userUid,
      productName: productName,
      brand: brand,
      imageUrl: imageUrl,
    );
  }
}
