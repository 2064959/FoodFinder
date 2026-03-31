import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:tpfinal/database_helper.dart';

class ProductRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Session storage (in-memory cache)
  static List<Product>? _popularProductsCache;

  /// Fetches popular products using a high-performance raw HTTP request.
  /// Results are saved in a persistent local database for instant re-access across app restarts.
  Future<List<Product>> fetchPopularProducts(int limit,
      {int offset = 0}) async {
    final stopwatch = Stopwatch()..start();

    // 1. Check Session Storage first for instant response (0ms)
    if (_popularProductsCache != null && _popularProductsCache!.isNotEmpty) {
      print(
          'OFF PERFORMANCE [CACHE]: Session Hit! Returning ${_popularProductsCache!.length} products in ${stopwatch.elapsedMilliseconds}ms');
      stopwatch.stop();
      return _popularProductsCache!;
    }

    // 2. Check Persistent Local Database for app restarts (0ms)
    try {
      final List<Product> localProducts =
          await _dbHelper.getPopularProducts(limit, offset: offset);
      if (localProducts.isNotEmpty) {
        print(
            'OFF PERFORMANCE [DATABASE]: Persistent Hit! Returning ${localProducts.length} products in ${stopwatch.elapsedMilliseconds}ms');

        // Cache in memory for subsequent quick access in this session
        _popularProductsCache = localProducts;

        // Return local data immediately to bypass network rate-limiting (503)
        stopwatch.stop();
        return localProducts;
      }
    } catch (e) {
      print('OFF PERFORMANCE [DATABASE]: Error reading cache: $e');
    }

    try {
      // 3. High-performance Modern V2 Search API with Quality Filters
      final String url = 'https://world.openfoodfacts.org/api/v2/search?'
          'sort_by=unique_scans_n&page_size=$limit'
          '&states_tags=en:complete' // Only fetch "complete" high-quality entries
          '&fields=product_name,brands,image_url,code,image_front_url,image_front_small_url,completeness,states_tags';

      print(
          'OFF PERFORMANCE [START]: Fetching high-quality popular products from network...');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent':
              'FoodFinderApp/1.0.0 (https://github.com/2064959/FoodFinder)',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      final networkTime = stopwatch.elapsedMilliseconds;
      print(
          'OFF PERFORMANCE [NETWORK]: Status ${response.statusCode} in ${networkTime}ms');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data.containsKey('products')) {
          final List<dynamic> productsJson = data['products'];

          final Map<String, double> completenessMap = {};
          final Map<String, List<String>> statesTagsMap = {};

          final List<Product> products = productsJson.map((json) {
            final p = Product.fromJson(json);
            if (p.barcode != null) {
              completenessMap[p.barcode!] =
                  (json['completeness'] as num?)?.toDouble() ?? 0.0;
              statesTagsMap[p.barcode!] =
                  List<String>.from(json['states_tags'] ?? []);

              // Quality log for debugging
              if (completenessMap[p.barcode!]! > 0) {
                print(
                    'OFF PERFORMANCE [QUALITY]: ${p.productName} - Score: ${(completenessMap[p.barcode!]! * 100).toInt()}%');
              }
            }
            return p;
          }).toList();

          print(
              'OFF PERFORMANCE [SUCCESS]: Network fetch complete in ${stopwatch.elapsedMilliseconds}ms');

          // 4. Save to Persistent Database and Session Cache for future use
          await _dbHelper.insertProducts(products,
              completenessMap: completenessMap, statesTagsMap: statesTagsMap);
          _popularProductsCache = products;

          stopwatch.stop();
          return products;
        }
      } else {
        print(
            'OFF PERFORMANCE [FAIL]: Server returned ${response.statusCode}. Falling back to DB cache.');
      }
    } catch (e) {
      print('OFF PERFORMANCE [ERROR]: $e. Falling back to DB cache.');
    }

    // 5. Final Fallback: Return whatever is in the DB, or hardcoded classic items
    try {
      final List<Product> lastChanceLocal =
          await _dbHelper.getPopularProducts(limit, offset: offset);
      if (lastChanceLocal.isNotEmpty) {
        print(
            'OFF PERFORMANCE [FALLBACK]: Serving stale database cache after network error/limit.');
        stopwatch.stop();
        return lastChanceLocal;
      }
    } catch (_) {}

    print(
        'OFF PERFORMANCE [FALLBACK]: No cache available. Triggering hardcoded classic items.');
    stopwatch.stop();
    return _fetchClassicFallback(limit);
  }

  /// Reliable fallback barcodes for when the OFF API search is unstable.
  Future<List<Product>> _fetchClassicFallback(int limit) async {
    final List<String> popularBarcodes = [
      '3017620422003', // Nutella
      '5449000000996', // Coca-Cola
      '7622210449283', // LU Prince
      '3033710065066', // Danone
      '3124480191182', // Volvic
      '3017624010701', // Ferrero Rocher
      '3046920022606', // Lindt Excellence
      '7613034626844', // Nesquik
      '3017230000063', // Bonne Maman
      '3228850000007', // Maille
    ];

    final List<Product> fetchedProducts = [];
    for (var barcode in popularBarcodes.take(limit)) {
      try {
        final ProductQueryConfiguration config = ProductQueryConfiguration(
          barcode,
          language: OpenFoodFactsLanguage.FRENCH,
          fields: [ProductField.ALL],
          version: ProductQueryVersion.v3,
        );
        final ProductResultV3 result =
            await OpenFoodAPIClient.getProductV3(config);
        if (result.status == ProductResultV3.statusSuccess &&
            result.product != null) {
          fetchedProducts.add(result.product!);
        }
      } catch (_) {
        // Individual product fetch failed, skip
      }
    }
    return fetchedProducts;
  }

  /// Searches for products by name or criteria via the OpenFoodFacts API.
  Future<List<Product>> searchProducts(String query, {int limit = 10}) async {
    try {
      final ProductSearchQueryConfiguration configuration =
          ProductSearchQueryConfiguration(
        parametersList: [
          SearchTerms(terms: [query]),
        ],
        language: OpenFoodFactsLanguage.FRENCH,
        fields: [ProductField.ALL],
        version: ProductQueryVersion.v3,
      );
      final SearchResult result = await OpenFoodAPIClient.searchProducts(
        const User(userId: '', password: ''),
        configuration,
      );
      return result.products ?? [];
    } catch (e) {
      throw Exception('Failed to search products: $e');
    }
  }

  /// Fetches a single product by barcode, checking local DB first.
  Future<Product?> getProductByBarcode(String barcode) async {
    try {
      // Check database first
      // In a real app, you might want more granular single-product fetch from DB.
      // DatabaseHelper already has some mapping for this.

      final ProductQueryConfiguration config = ProductQueryConfiguration(
        barcode,
        language: OpenFoodFactsLanguage.FRENCH,
        fields: [ProductField.ALL],
        version: ProductQueryVersion.v3,
      );
      final ProductResultV3 result =
          await OpenFoodAPIClient.getProductV3(config);
      return result.product;
    } catch (e) {
      throw Exception('Failed to fetch product for barcode $barcode: $e');
    }
  }
}
