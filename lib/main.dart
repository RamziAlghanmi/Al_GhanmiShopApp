import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/Screens/home_screen.dart';
import 'package:shop_app/Screens/login_screen.dart';
import 'package:shop_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shop_app/providers/favorites_provider.dart';
import 'package:shop_app/providers/product_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop_app/Services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthService _auth = AuthService();
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(
          create: (_) => ProductProvider()..loadAllProducts(),
        ),

        ChangeNotifierProvider(
          create: (_) =>
              FavoritesProvider(FirebaseAuth.instance.currentUser!.uid),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'متجري الإلكتروني',
        locale: const Locale('ar'),
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          );
        },

        theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Cairo'),
        home: StreamBuilder<User?>(
          stream: _auth.user,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            if (snapshot.hasData && snapshot.data != null) {
              return HomeScreen(user: snapshot.data!);
            }
            return LoginScreen();
          },
        ),
      ),
    );
  }
}
