import 'package:flutter/material.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final List<Product> _cartItems = [];

  List<Product> get cartItems => _cartItems;

  int get cartItemCount => _cartItems.length;

  double get totalPrice =>
      _cartItems.fold(0, (sum, item) => sum + item.price);

  void addToCart(Product product) {
    _cartItems.add(product);
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _cartItems.remove(product);
    notifyListeners();
  }

  bool isInCart(Product product) {
    return _cartItems.any((item) => item.id == product.id);
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}