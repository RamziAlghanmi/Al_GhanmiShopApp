import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

// class ApiService {
//   static const String baseUrl =
//       //'https://6a2312c25c610353286ab169.mockapi.io/api/alghanmiproducts/products';
//       'https://dummyjson.com/products';

//   static Future<List<Product>> fetchProducts() async {
//     final response = await http.get(Uri.parse(baseUrl));

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       return (data['products'] as List)
//           .map((item) => Product.fromJson(item))
//           .toList();
//     } else {
//       throw Exception('فشل تحميل المنتجات');
//     }
//   }
// }
