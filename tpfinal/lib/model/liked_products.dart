class LikedProduct {
  final String idProduct;
  final DateTime whenLiked;

  LikedProduct({required this.idProduct, required this.whenLiked});

  // Convert a LikedProduct into a Map. The keys must correspond to the column names.
  Map<String, dynamic> toMap() {
    return {
      'idProduct': idProduct,
      'whenLiked': whenLiked.toIso8601String(),
    };
  }

  // Extract a LikedProduct from a Map. The keys must correspond to the column names.
  factory LikedProduct.fromMap(Map<String, dynamic> map) {
    return LikedProduct(
      idProduct: map['idProduct'],
      whenLiked: DateTime.parse(map['whenLiked']),
    );
  }

  factory LikedProduct.fromProduct(String idProduct) {
    return LikedProduct(
      idProduct: idProduct,
      whenLiked: DateTime.now(),
    );
  }
}
