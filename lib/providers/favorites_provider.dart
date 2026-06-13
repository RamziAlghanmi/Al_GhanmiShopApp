import 'package:flutter/material.dart';
import '../models/product.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<Product> _favoriteItems = [];

  List<Product> get favoriteItems => _favoriteItems;

  int get favoriteItemCount => _favoriteItems.length;

  void toggleFavorite(Product product) {
    if (isFavorite(product)) {
      _favoriteItems.removeWhere((item) => item.id == product.id);
    } else {
      _favoriteItems.add(product);
    }
    notifyListeners();
  }

  bool isFavorite(Product product) {
    return _favoriteItems.any((item) => item.id == product.id);
  }

  void removeFromFavorites(Product product) {
    _favoriteItems.removeWhere((item) => item.id == product.id);
    notifyListeners();
  }
}
