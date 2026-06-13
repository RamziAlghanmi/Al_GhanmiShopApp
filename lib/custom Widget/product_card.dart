import 'package:flutter/material.dart';
import 'package:shop_app/models/product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: EdgeInsets.all(10),
        // height: 300,
        // width: 200,
        color: const Color.fromARGB(134, 241, 239, 239),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Container(
              width: double.infinity,
              height: 300,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: .circular(15),
              ),

              child: Image.network(
                product.thumbnail,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(
                  getCategoryIcon(product.category),
                  size: 60,
                  color: Colors.blue,
                ),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // السعر
                Text(
                  '    ${product.price.toStringAsFixed(2)} ريال',
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Text(
                  'الوصف:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                Text(
                  '     ${product.description}',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

IconData getCategoryIcon(String category) {
  switch (category) {
    case 'إلكترونيات':
      return Icons.devices;
    case 'ملابس':
      return Icons.checkroom;
    case 'كتب':
      return Icons.book;
    default:
      return Icons.category;
  }
}
