import 'dart:async';
import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:tpfinal/repositories/product_repository.dart';
import 'package:tpfinal/util/app_constants.dart';

class ProductProvider with ChangeNotifier {
  final ProductRepository _productRepo = ProductRepository();
  
  List<Product> _popularProducts = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasReachedMax = false;
  String? _errorMessage;
  Timer? _refreshTimer;

  ProductProvider() {
    _startPeriodicRefresh();
  }

  List<Product> get popularProducts => _popularProducts;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasReachedMax => _hasReachedMax;
  String? get errorMessage => _errorMessage;

  void _startPeriodicRefresh() {
    // Refresh every 10 minutes
    _refreshTimer = Timer.periodic(const Duration(minutes: 10), (timer) {
      print('OFF PERFORMANCE [REFRESH]: Triggering background quality refresh...');
      silentRefreshPopularProducts();
    });
  }

  /// Initial load of popular products
  Future<void> fetchPopularProducts() async {
    if (_popularProducts.isNotEmpty) return; // Already loaded

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final products = await _productRepo.fetchPopularProducts(AppConstants.popularProductsLimit);
      _popularProducts = products;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Silent background refresh
  Future<void> silentRefreshPopularProducts() async {
    try {
      // Fetch without setting isLoading=true to avoid UI flicker
      final products = await _productRepo.fetchPopularProducts(AppConstants.popularProductsLimit);
      if (products.isNotEmpty) {
        _popularProducts = products;
        notifyListeners();
        print('OFF PERFORMANCE [REFRESH]: Silent update successful.');
      }
    } catch (e) {
      print('OFF PERFORMANCE [REFRESH]: Silent refresh failed: $e');
    }
  }

  /// Load more popular products (pagination)
  Future<void> loadMorePopularProducts() async {
    if (_isLoadingMore || _hasReachedMax) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final nextProducts = await _productRepo.fetchPopularProducts(
        AppConstants.popularProductsLimit,
        offset: _popularProducts.length,
      );

      if (nextProducts.isEmpty) {
        _hasReachedMax = true;
      } else {
        _popularProducts.addAll(nextProducts);
      }
      
      _isLoadingMore = false;
      notifyListeners();
    } catch (e) {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// Refresh popular products manually
  Future<void> refreshPopularProducts() async {
    _popularProducts = [];
    _hasReachedMax = false;
    await fetchPopularProducts();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }
}
