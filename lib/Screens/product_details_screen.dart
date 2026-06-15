import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/custom%20Widget/product_card.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/favorites_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: .rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(product.title)),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductCard(product: product),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: Consumer<CartProvider>(
                      builder: (context, cart, child) {
                        final isInCart = cart.isInCart(product);
                        return ElevatedButton.icon(
                          onPressed: () {
                            if (isInCart) {
                              cart.removeFromCart(product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('تم إزالة المنتج من السلة'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            } else {
                              cart.addToCart(product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('تم إضافة المنتج إلى السلة'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            }
                          },
                          icon: Icon(
                            isInCart
                                ? Icons.shopping_cart
                                : Icons.add_shopping_cart,
                          ),
                          label: Text(
                            isInCart ? 'إزالة من السلة' : 'إضافة للسلة',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isInCart
                                ? Colors.orange
                                : Colors.blue,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),

                  Expanded(
                    child: Consumer<FavoritesProvider>(
                      builder: (context, favorites, child) {
                        final isFavorite = favorites.isFavorite(product);
                        return OutlinedButton.icon(
                          onPressed: () {
                            favorites.toggleFavorite(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isFavorite
                                      ? 'تم إزالة المنتج من المفضلة'
                                      : 'تم إضافة المنتج إلى المفضلة',
                                ),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : null,
                          ),
                          label: Text(
                            isFavorite ? 'إزالة من المفضلة' : 'إضافة للمفضلة',
                          ),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
