import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/favorites_provider.dart';
import 'package:shop_app/Screens/add_product_screen.dart';
import 'package:shop_app/Screens/cart_screen.dart';
import 'package:shop_app/Screens/categories_screen.dart';
import 'package:shop_app/Screens/category_products_screen.dart';
import 'package:shop_app/Screens/favorites_screen.dart';
import 'package:shop_app/Screens/product_details_screen.dart';
import 'package:shop_app/custom%20Widget/product_card.dart';
import 'package:shop_app/custom%20Widget/product_small_card.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/product_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop_app/Services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  final User? user;
  const HomeScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
  
    final auth = AuthService();
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('المستخدم غير مسجل الدخول')),
      );
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text('متجري الإلكتروني'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.favorite_border),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                );
              },
            ),

            Consumer<CartProvider>(
              builder: (context, cart, child) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => const CartScreen()),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shopping_cart),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) => const CartScreen()),
                            ),
                          );
                        },
                      ),
                      if (cart.cartItemCount > 0)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 18,
                              minHeight: 18,
                            ),
                            child: Text(
                              '${cart.cartItemCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                title: Text('تسجيل الخروج'),
                onTap: () async {
                  await auth.signOut();
                },
              ),
            ],
          ),
        ),
        body: Consumer<ProductProvider>(
          builder: (context, productProvider, child) {
            if (productProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (productProvider.errorMessage != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('خطأ: ${productProvider.errorMessage}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => productProvider.loadAllProducts(),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }
            final categorized = productProvider.categorizedProducts;

            return RefreshIndicator(
              onRefresh: () => productProvider.refreshProducts(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CategoriesScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.category),
                        label: const Text('عرض جميع الفئات'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),
                    ),

                    ...categorized.entries.map(
                      (entry) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      getCategoryIcon(entry.key),

                                      size: 30,
                                      color: Colors.blue,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      entry.key,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => CategoryProductsScreen(
                                          category: entry.key,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text('عرض الكل'),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              itemCount: entry.value.length,
                              itemBuilder: (context, index) {
                                final product = entry.value[index];
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ProductDetailsScreen(
                                          product: product,
                                        ),
                                      ),
                                    );
                                  },
                                  child: ProductSmallCard(product: product),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      if(user.uid =="64hMTuoZyWROICypGnbaC4r8tio2")
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddProductScreen()),
            ).then((_) {
              context.read<ProductProvider>().refreshProducts();
            });
          },
          label: const Icon(Icons.add),
        ),
      ),
    );
  }
}
