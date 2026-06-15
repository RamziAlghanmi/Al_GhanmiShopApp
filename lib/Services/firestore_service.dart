import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app/models/product.dart';


class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Product> _favorites = [];
  static const List<String> storeCategories = ['إلكترونيات', 'ملابس', 'كتب'];
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

  List<Product> loadFavorites(String userId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .snapshots()
        .listen((snapshot) {
          _favorites = snapshot.docs
              .map((doc) => Product.fromFirestore(doc))
              .toList();
        });
    return _favorites;
  }
Future<void> toggleFavorite(Product product, String userId) async {
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

  static List<String> getAvailableCategories() {
    return storeCategories;
  }

  Future<void> removeFromFavorite(Product product, String userId) async {
     final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(product.id);

    final doc = await docRef.get();
    if (doc.exists) {
      await docRef.delete();
    } 
  }

}
