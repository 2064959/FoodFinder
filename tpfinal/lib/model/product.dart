class ProductItem {
  final String code;
  final String productName;
  final String genericName;
  final String brands;
  final List<String> brandsTags;
  final String countries;
  final List<String> countriesTags;
  final String lang;
  final String quantity;
  final String imageFrontUrl;
  final String imageFrontSmallUrl;
  final String imageIngredientsUrl;
  final String imageIngredientsSmallUrl;
  final String imageNutritionUrl;
  final String imageNutritionSmallUrl;
  final String imagePackagingUrl;

  ProductItem({
    required this.code,
    required this.productName,
    required this.genericName,
    required this.brands,
    required this.brandsTags,
    required this.countries,
    required this.countriesTags,
    required this.lang,
    required this.quantity,
    required this.imageFrontUrl,
    required this.imageFrontSmallUrl,
    required this.imageIngredientsUrl,
    required this.imageIngredientsSmallUrl,
    required this.imageNutritionUrl,
    required this.imageNutritionSmallUrl,
    required this.imagePackagingUrl,
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      code: json['code'].toString(),
      productName: json['product_name'],
      genericName: json['generic_name'],
      brands: json['brands'],
      brandsTags: List<String>.from(json['brands_tags']),
      countries: json['countries'],
      countriesTags: List<String>.from(json['countries_tags']),
      lang: json['lang'],
      quantity: json['quantity'],
      imageFrontUrl: json['image_front_url'],
      imageFrontSmallUrl: json['image_front_small_url'],
      imageIngredientsUrl: json['image_ingredients_url'],
      imageIngredientsSmallUrl: json['image_ingredients_small_url'],
      imageNutritionUrl: json['image_nutrition_url'],
      imageNutritionSmallUrl: json['image_nutrition_small_url'],
      imagePackagingUrl: json['image_packaging_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'product_name': productName,
      'generic_name': genericName,
      'brands': brands,
      'brands_tags': brandsTags,
      'countries': countries,
      'countries_tags': countriesTags,
      'lang': lang,
      'quantity': quantity,
      'image_front_url': imageFrontUrl,
      'image_front_small_url': imageFrontSmallUrl,
      'image_ingredients_url': imageIngredientsUrl,
      'image_ingredients_small_url': imageIngredientsSmallUrl,
      'image_nutrition_url': imageNutritionUrl,
      'image_nutrition_small_url': imageNutritionSmallUrl,
      'image_packaging_url': imagePackagingUrl,
    };
  }
}