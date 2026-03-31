import 'package:openfoodfacts/openfoodfacts.dart';

class ProductFormatter {
  static String getIngredientPercentage(Product product, Nutrient nutrient) {
    final double? value = product.nutriments?.getValue(nutrient, PerSize.oneHundredGrams);
    return "${(value ?? 0).toStringAsFixed(1)}%";
  }

  static String getEnergyKcal(Product product) {
    final double? value = product.nutriments?.getValue(Nutrient.energyKCal, PerSize.oneHundredGrams);
    return "${value?.round() ?? 0} Kcal";
  }

  static String getEnergyPercentage(Product product) {
    final double? kcal = product.nutriments?.getValue(Nutrient.energyKCal, PerSize.oneHundredGrams);
    final double? kj = product.nutriments?.getValue(Nutrient.energyKJ, PerSize.oneHundredGrams);
    
    if (kcal == null || kcal == 0) return "0.0%";
    return "${((kj ?? 0) / kcal).toStringAsFixed(1)}%";
  }

  static String getProductDescription(Product product) {
    // Try in order of preference for description
    String? description = product.ingredientsText ?? 
                         product.genericName ?? 
                         product.productName;
    
    if (description != null && description.trim().isNotEmpty) {
      return description.trim();
    }
    
    // Last resort fallback
    if (product.brands != null) {
      return "A product from ${product.brands}. No detailed description available.";
    }
    
    return "No description available for this product.";
  }

  static String getPerUnitLabel(Product product) {
    // OpenFoodFacts API usually returns data per 100g or per serving
    return "per 100g";
  }

}
