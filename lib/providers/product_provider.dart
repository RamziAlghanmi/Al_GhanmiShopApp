import 'package:flutter/material.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/Services/firestore_service.dart';


class ProductProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<String> _categories = [];
  List<Product> _allProducts = [];
  Map<String, List<Product>> _categorizedProducts = {};
  bool _isLoading = false;
  String? _errorMessage;

  List<String> get categories => _categories;
  List<Product> get allProducts => _allProducts;
  Map<String, List<Product>> get categorizedProducts => _categorizedProducts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadAllProducts() async {
    _isLoading = true;
    _errorMessage = null;
    try {
      _allProducts = await _firestoreService.fetchAllProducts();
      _categories = FirestoreService.storeCategories;
      _categorizedProducts = {};
      for (String category in FirestoreService.storeCategories) {
        _categorizedProducts[category] = _allProducts
            .where((p) => p.category == category)
            .toList();
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> refreshProducts() async {
    await loadAllProducts();
  }
}
