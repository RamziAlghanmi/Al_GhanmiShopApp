import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app/models/product.dart';

class FavoritesProvider extends ChangeNotifier {
  final String userId;
  List<Product> _favoriteItems = [];
  StreamSubscription? _favoritesSubscription;

  FavoritesProvider(this.userId) {
    _listenToFavorites();
  }

  List<Product> get favoriteItems => _favoriteItems;
  int get favoriteItemCount => _favoriteItems.length;

  void _listenToFavorites() {
    _favoritesSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .snapshots()
        .listen((snapshot) {
      _favoriteItems = snapshot.docs
          .map((doc) => Product.fromFirestore(doc))
          .toList();
      notifyListeners();
    });
  }

  Future<void> toggleFavorite(Product product) async {
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(product.id);

    final doc = await docRef.get();
    if (doc.exists) {
      await docRef.delete();
    } else {
      await docRef.set(product.toMap());
    }
    
  }

  bool isFavorite(Product product) {
    return _favoriteItems.any((item) => item.id == product.id);
  }
  
  Future<void> removeFromFavorites(Product product) async {
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(product.id);
    await docRef.delete();
  }

  @override
  void dispose() {
    _favoritesSubscription?.cancel();
    super.dispose();
  }
}
