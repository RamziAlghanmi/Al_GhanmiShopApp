import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/custom%20Widget/product_small_card.dart';
import 'package:shop_app/providers/product_provider.dart';
import 'package:shop_app/Screens/product_details_screen.dart';

class CategoryProductsScreen extends StatelessWidget {
  final String category;

  const CategoryProductsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: .rtl,
      child: Scaffold(
        appBar: AppBar(title: Text('منتجات $category')),
        body: Consumer<ProductProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (provider.errorMessage != null) {
              return Center(child: Text('خطأ: ${provider.errorMessage}'));
            }
            final products = provider.categorizedProducts;

            if (products.isEmpty) {
              return const Center(child: Text('لا توجد منتجات في هذه الفئة'));
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 250,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),

              itemCount: products[category]!.length,
              itemBuilder: (context, index) {
                final product = products[category];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ProductDetailsScreen(product: product[index]),
                      ),
                    );
                  },
                  child: ProductSmallCard(product: product![index]),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

