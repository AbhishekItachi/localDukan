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
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: MaterialApp(
        title: 'Local Dukan',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.green),
        initialRoute: '/home',
        onGenerateRoute: (settings) {
    if (settings.name == '/confirmation') {
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (context) => OrderConfirmationScreen(slot: args['slot']),
      );
    }
    // Default routing
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case '/checkout':
        return MaterialPageRoute(builder: (_) => CheckoutScreen());
      case '/cart':
        return MaterialPageRoute(builder: (_) => CartScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(body: Center(child: Text('404 Not Found'))),
        );
    }
  },
        // routes: {
        //   '/': (context) => LoginScreen(),
        //   '/home': (context) => HomeScreen(),
        //   '/cart': (context) => CartScreen(),
        //   '/checkout': (context) => CheckoutScreen(),
        // },
      ),
    );
  }
}
