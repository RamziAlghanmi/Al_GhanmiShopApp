import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // الفئات المسموحة في المتجر (بالعربية)
  static const List<String> storeCategories = ['إلكترونيات', 'ملابس', 'كتب'];

  // جلب جميع المنتجات
  Future<List<Product>> fetchAllProducts() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('products').get();
      return snapshot.docs
          .map((doc) => Product.fromFirestore(doc))
          .where((product) => storeCategories.contains(product.category))
          .toList();
    } catch (e) {
      throw Exception('خطأ في جلب المنتجات: $e');
    }
  }

  // جلب منتجات فئة محددة
  Future<List<Product>> fetchProductsByCategory(String category) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('products')
          .where('category', isEqualTo: category)
          .get();
      return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('خطأ في جلب منتجات الفئة: $e');
    }
  }

  // جلب الفئات المتاحة (نفس الثابت)
  static List<String> getAvailableCategories() {
    return storeCategories;
  }
}
