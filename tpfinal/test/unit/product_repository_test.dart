import 'package:flutter_test/flutter_test.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:tpfinal/util/product_formatter.dart';

void main() {
  group('ProductFormatter Tests', () {
    test('getProductDescription returns ingredientsText if available', () {
      final product = Product(ingredientsText: 'Test Ingredients');
      expect(ProductFormatter.getProductDescription(product), 'Test Ingredients');
    });

    test('getProductDescription returns genericName if ingredientsText is missing', () {
      final product = Product(genericName: 'Test Generic Name');
      expect(ProductFormatter.getProductDescription(product), 'Test Generic Name');
    });

    test('getProductDescription returns default message if both are missing', () {
      final product = Product();
      expect(ProductFormatter.getProductDescription(product), 'No description available for this product.');
    });

    test('getIngredientPercentage handles null nutriments', () {
      final product = Product();
      expect(ProductFormatter.getIngredientPercentage(product, Nutrient.sugars), '0.0%');
    });
  });
}

