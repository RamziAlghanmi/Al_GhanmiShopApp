import 'package:flutter/material.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/services/firestore_service.dart';


class FavoritesProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final String userId;
  List<Product> _favoriteItems = [];

  List<Product> get favoriteItems => _favoriteItems;

  int get favoriteItemCount => _favoriteItems.length;

  FavoritesProvider(this.userId) {
    _favoriteItems = _firestoreService.loadFavorites(userId);
    notifyListeners();
  }

  Future<void> toggleFavorite(Product product) async {
    return _firestoreService.toggleFavorite(product, userId);
  }

  bool isFavorite(Product product) {
    return _favoriteItems.any((item) => item.id == product.id);
  }

  void removeFromFavorites(Product product) {
    _firestoreService.removeFromFavorite(product, userId);
    _favoriteItems = _firestoreService.loadFavorites(userId);
    notifyListeners();
  }
}
