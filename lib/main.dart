import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/firebase_options.dart';
import 'package:shop_app/providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/favorites_provider.dart';
import 'Screens/home_screen.dart';


void main() async{
 WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(
          create: (_) => ProductProvider()..loadAllProducts(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'متجري الإلكتروني',
        locale: const Locale('ar'),

        theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Cairo'),
        home: const HomeScreen(),
        // home: ProductCard(product: pro),
      ),
    );
  }
}
