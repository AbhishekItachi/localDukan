import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/cart_screen.dart';
import 'providers/cart_provider.dart';
import 'providers/favorites_provider.dart';
import 'screens/checkout_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cartProvider = CartProvider();
  await cartProvider.loadCart();

  final favProvider = FavoritesProvider();
  await favProvider.loadFavorites();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => cartProvider),
      ChangeNotifierProvider(create: (_) => favProvider),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: MaterialApp(
        title: 'Local Dukan',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.green),
        initialRoute: '/home',
        routes: {
          '/': (context) => LoginScreen(),
          '/home': (context) => HomeScreen(),
          '/cart': (context) => CartScreen(),
          '/checkout': (context) => CheckoutScreen(),
          '/confirmation': (context) => OrderConfirmationScreen(),
        },
      ),
    );
  }
}
