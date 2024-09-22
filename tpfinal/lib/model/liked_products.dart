class LikedProduct {
  final String idProduct;
  final DateTime whenLiked;
  final String userUid;

  LikedProduct({required this.idProduct, required this.whenLiked, required this.userUid});

  // Convert a LikedProduct into a Map. The keys must correspond to the column names.
  Map<String, dynamic> toMap() {
    return {
      'idProduct': idProduct,
      'whenLiked': whenLiked.toIso8601String(),
      'userUid': userUid,
    };
  }

  // Extract a LikedProduct from a Map. The keys must correspond to the column names.
  factory LikedProduct.fromMap(Map<String, dynamic> map) {
    return LikedProduct(
      idProduct: map['idProduct'],
      whenLiked: DateTime.parse(map['whenLiked']),
      userUid: map['userUid'],
    );
  }

  factory LikedProduct.fromProduct(String idProduct, String userUid) {
    return LikedProduct(
      idProduct: idProduct,
      whenLiked: DateTime.now(),
      userUid: userUid,
    );
  }
}
