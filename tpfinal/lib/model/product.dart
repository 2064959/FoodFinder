import 'package:openfoodfacts/openfoodfacts.dart';

class ProductItem {
  final String? barcode;
  final String? productName;
  final Map<OpenFoodFactsLanguage, String>? productNameInLanguages;
  final String? genericName;
  final String? brands;
  final List<String>? brandsTags;
  final String? countries;
  final List<String>? countriesTags;
  final Map<OpenFoodFactsLanguage, List<String>>? countriesTagsInLanguages;
  final OpenFoodFactsLanguage? lang;
  final String? quantity;
  final String? imageFrontUrl;
  final String? imageFrontSmallUrl;
  final String? imageIngredientsUrl;
  final String? imageIngredientsSmallUrl; 
  final String? imageNutritionUrl;
  final String? imageNutritionSmallUrl;
  final String? imagePackagingUrl; 
  final String? imagePackagingSmallUrl;
  final String? servingSize; 
  final double? servingQuantity;
  final double? packagingQuantity;
  final List<ProductImage>? selectedImages;
  final List<ProductImage>? images; 
  final List<Ingredient>? ingredients;
  final String? ingredientsText;
  final Map<OpenFoodFactsLanguage, String>? ingredientsTextInLanguages;
  final List<String>? ingredientsTags; 
  final Map<OpenFoodFactsLanguage, List<String>>? ingredientsTagsInLanguages;
  final IngredientsAnalysisTags? ingredientsAnalysisTags; 
  final Additives? additives;
  final Allergens? allergens;
  final NutrientLevels? nutrientLevels;
  final String? nutrimentEnergyUnit;
  final String? nutrimentDataPer;
  final String? nutriscore;
  final String? categories;
  final List<String>? categoriesTags;
  final Map<OpenFoodFactsLanguage, List<String>>? categoriesTagsInLanguages;
  final String? labels;
  final List<String>? labelsTags; 
  final Map<OpenFoodFactsLanguage, List<String>>? labelsTagsInLanguages;
  final String? packaging; 
  final List<String>? packagingTags;
  final List<String>? miscTags; 
  final List<String>? statesTags; 
  final List<String>? tracesTags; 
  final List<String>? storesTags;
  final String? stores;
  final List<AttributeGroup>? attributeGroups; 
  final DateTime? lastModified; 
  final String? ecoscoreGrade;
  final double? ecoscoreScore; 
  final EcoscoreData? ecoscoreData; 
  final Nutriments? nutriments;
  final bool? noNutritionData;


 
  ProductItem({
    this.barcode,
    this.productName,
    this.productNameInLanguages,
    this.genericName,
    this.brands,
    this.brandsTags,
    this.countries,
    this.countriesTags,
    this.countriesTagsInLanguages,
    this.lang,
    this.quantity,
    this.imageFrontUrl,
    this.imageFrontSmallUrl,
    this.imageIngredientsUrl,
    this.imageIngredientsSmallUrl,
    this.imageNutritionUrl,
    this.imageNutritionSmallUrl,
    this.imagePackagingUrl,
    this.imagePackagingSmallUrl,
    this.servingSize,
    this.servingQuantity,
    this.packagingQuantity,
    this.selectedImages,
    this.images,
    this.ingredients,
    this.ingredientsText,
    this.ingredientsTextInLanguages,
    this.ingredientsTags,
    this.ingredientsTagsInLanguages,
    this.ingredientsAnalysisTags,
    this.additives,
    this.allergens,
    this.nutrientLevels,
    this.nutrimentEnergyUnit,
    this.nutrimentDataPer,
    this.nutriscore,
    this.categories,
    this.categoriesTags,
    this.categoriesTagsInLanguages,
    this.labels,
    this.labelsTags,
    this.labelsTagsInLanguages,
    this.packaging,
    this.packagingTags,
    this.miscTags,
    this.statesTags,
    this.tracesTags,
    this.storesTags,
    this.stores,
    this.attributeGroups,
    this.lastModified,
    this.ecoscoreGrade,
    this.ecoscoreScore,
    this.ecoscoreData,
    this.nutriments,
    this.noNutritionData,  
  });

  factory ProductItem.fromProduct(Product product) {
    return ProductItem(
      barcode: product.barcode,
      productName: product.productName,
      productNameInLanguages: product.productNameInLanguages,
      genericName: product.genericName,
      brands: product.brands,
      brandsTags: product.brandsTags,
      countries: product.countries,
      countriesTags: product.countriesTags,
      countriesTagsInLanguages: product.countriesTagsInLanguages,
      lang: product.lang,
      quantity: product.quantity,
      imageFrontUrl: product.imageFrontUrl,
      imageFrontSmallUrl: product.imageFrontSmallUrl,
      imageIngredientsUrl: product.imageIngredientsUrl,
      imageIngredientsSmallUrl: product.imageIngredientsSmallUrl,
      imageNutritionUrl: product.imageNutritionUrl,
      imageNutritionSmallUrl: product.imageNutritionSmallUrl,
      imagePackagingUrl: product.imagePackagingUrl,
      imagePackagingSmallUrl: product.imagePackagingSmallUrl,
      servingSize: product.servingSize,
      servingQuantity: product.servingQuantity,
      packagingQuantity: product.packagingQuantity,
      selectedImages: product.selectedImages,
      images: product.images,
      ingredients: product.ingredients,
      ingredientsText: product.ingredientsText,
      ingredientsTextInLanguages: product.ingredientsTextInLanguages,
      ingredientsTags: product.ingredientsTags,
      ingredientsTagsInLanguages: product.ingredientsTagsInLanguages,
      ingredientsAnalysisTags: product.ingredientsAnalysisTags,
      additives: product.additives,
      allergens: product.allergens,
      nutrientLevels: product.nutrientLevels,
      nutrimentEnergyUnit: product.nutrimentEnergyUnit,
      nutrimentDataPer: product.nutrimentDataPer,
      nutriscore: product.nutriscore,
      categories: product.categories,
      categoriesTags: product.categoriesTags,
      categoriesTagsInLanguages: product.categoriesTagsInLanguages,
      labels: product.labels,
      labelsTags: product.labelsTags,
      labelsTagsInLanguages: product.labelsTagsInLanguages,
      packaging: product.packaging,
      packagingTags: product.packagingTags,
      miscTags: product.miscTags,
      statesTags: product.statesTags,
      tracesTags: product.tracesTags,
      storesTags: product.storesTags,
      stores: product.stores,
      attributeGroups: product.attributeGroups,
      lastModified: product.lastModified,
      ecoscoreGrade: product.ecoscoreGrade,
      ecoscoreScore: product.ecoscoreScore,
      ecoscoreData: product.ecoscoreData,
      nutriments: product.nutriments,
      noNutritionData: product.noNutritionData,
    );
  }

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      barcode: json['code'],
      productName: json['product_name'],
      productNameInLanguages: json['product_name_in_languages'],
      genericName: json['generic_name'],
      brands: json['brands'],
      brandsTags: json['brands_tags'],
      countries: json['countries'],
      countriesTags: json['countries_tags'],
      countriesTagsInLanguages: json['countries_tags_in_languages'],
      lang: json['lang'],
      quantity: json['quantity'],
      imageFrontUrl: json['image_front_url'],
      imageFrontSmallUrl: json['image_front_small_url'],
      imageIngredientsUrl: json['image_ingredients_url'],
      imageIngredientsSmallUrl: json['image_ingredients_small_url'],
      imageNutritionUrl: json['image_nutrition_url'],
      imageNutritionSmallUrl: json['image_nutrition_small_url'],
      imagePackagingUrl: json['image_packaging_url'],
      imagePackagingSmallUrl: json['image_packaging_small_url'],
      servingSize: json['serving_size'],
      servingQuantity: json['serving_quantity'],
      packagingQuantity: json['packaging_quantity'],
      selectedImages: json['selected_images'],
      images: json['images'],
      ingredients: json['ingredients'],
      ingredientsText: json['ingredients_text'],
      ingredientsTextInLanguages: json['ingredients_text_in_languages'],
      ingredientsTags: json['ingredients_tags'],
      ingredientsTagsInLanguages: json['ingredients_tags_in_languages'],
      ingredientsAnalysisTags: json['ingredients_analysis_tags'],
      additives: json['additives'],
      allergens: json['allergens'],
      nutrientLevels: json['nutrient_levels'],
      nutrimentEnergyUnit: json['nutriment_energy_unit'],
      nutrimentDataPer: json['nutriment_data_per'],
      nutriscore: json['nutriscore'],
      categories: json['categories'],
      categoriesTags: json['categories_tags'],
      categoriesTagsInLanguages: json['categories_tags_in_languages'],
      labels: json['labels'],
      labelsTags: json['labels_tags'],
      labelsTagsInLanguages: json['labels_tags_in_languages'],
      packaging: json['packaging'],
      packagingTags: json['packaging_tags'],
      miscTags: json['misc_tags'],
      statesTags: json['states_tags'],
      tracesTags: json['traces_tags'],
      storesTags: json['stores_tags'],
      stores: json['stores'],
      attributeGroups: json['attribute_groups'],
      lastModified: json['last_modified'],
      ecoscoreGrade: json['ecoscore_grade'],
      ecoscoreScore: json['ecoscore_score'],
      ecoscoreData: json['ecoscore_data'],
      nutriments: json['nutriments'],
      noNutritionData: json['no_nutrition_data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': barcode,
      'product_name': productName,
      'product_name_in_languages': productNameInLanguages,
      'generic_name': genericName,
      'brands': brands,
      'brands_tags': brandsTags,
      'countries': countries,
      'countries_tags': countriesTags,
      'countries_tags_in_languages': countriesTagsInLanguages,
      'lang': lang,
      'quantity': quantity,
      'image_front_url': imageFrontUrl,
      'image_front_small_url': imageFrontSmallUrl,
      'image_ingredients_url': imageIngredientsUrl,
      'image_ingredients_small_url': imageIngredientsSmallUrl,
      'image_nutrition_url': imageNutritionUrl,
      'image_nutrition_small_url': imageNutritionSmallUrl,
      'image_packaging_url': imagePackagingUrl,
      'image_packaging_small_url': imagePackagingSmallUrl,
      'serving_size': servingSize,
      'serving_quantity': servingQuantity,
      'packaging_quantity': packagingQuantity,
      'selected_images': selectedImages,
      'images': images,
      'ingredients': ingredients,
      'ingredients_text': ingredientsText,
      'ingredients_text_in_languages': ingredientsTextInLanguages,
      'ingredients_tags': ingredientsTags,
      'ingredients_tags_in_languages': ingredientsTagsInLanguages,
      'ingredients_analysis_tags': ingredientsAnalysisTags,
      'additives': additives,
      'allergens': allergens,
      'nutrient_levels': nutrientLevels,
      'nutriment_energy_unit': nutrimentEnergyUnit,
      'nutriment_data_per': nutrimentDataPer,
      'nutriscore': nutriscore,
      'categories': categories,
      'categories_tags': categoriesTags,
      'categories_tags_in_languages': categoriesTagsInLanguages,
      'labels': labels,
      'labels_tags': labelsTags,
      'labels_tags_in_languages': labelsTagsInLanguages,
      'packaging': packaging,
      'packaging_tags': packagingTags,
      'misc_tags': miscTags,
      'states_tags': statesTags,
      'traces_tags': tracesTags,
      'stores_tags': storesTags,
      'stores': stores,
      'attribute_groups': attributeGroups,
      'last_modified': lastModified,
      'ecoscore_grade': ecoscoreGrade,
      'ecoscore_score': ecoscoreScore,
      'ecoscore_data': ecoscoreData,
      'nutriments': nutriments,
      'no_nutrition_data': noNutritionData,
    };
  }
}