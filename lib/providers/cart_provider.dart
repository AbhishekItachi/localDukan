import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_item.dart';
import '../models/grocery_item.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  int get totalItems => _items.length;

  double get totalPrice =>
      _items.values.fold(0, (sum, cartItem) => sum + cartItem.item.price * cartItem.quantity);

  int get totalItemsCount =>
    _items.values.fold(0, (sum, item) => sum + item.quantity);

  void addToCart(GroceryItem item) {
    if (_items.containsKey(item.name)) {
      _items[item.name]!.quantity++;
    } else {
      _items[item.name] = CartItem(item: item);
    }
    notifyListeners();
  }

  void removeFromCart(String itemName) {
    _items.remove(itemName);
    notifyListeners();
  }

  void increaseQuantity(String itemName) {
    _items[itemName]?.quantity++;
    notifyListeners();
  }

  void decreaseQuantity(String itemName) {
    if (_items[itemName] != null) {
      _items[itemName]!.quantity--;
      if (_items[itemName]!.quantity <= 0) {
        _items.remove(itemName);
      }
      notifyListeners();
    }
  }

  void changeQuantity(String name, int change) {
  if (_items.containsKey(name)) {
    _items[name]!.quantity += change;

    if (_items[name]!.quantity <= 0) {
      _items.remove(name); // Remove if quantity drops to 0
    }

    notifyListeners();
    saveCart();
  }
}

  Future<void> loadCart() async {
  final prefs = await SharedPreferences.getInstance();
  final cartData = prefs.getString('cart');
  if (cartData != null) {
    final decoded = json.decode(cartData) as Map<String, dynamic>;
    _items.clear();
    decoded.forEach((key, value) {
      final item = GroceryItem(
        name: value['name'],
        price: value['price'],
        image: value['image'],
        category: value['category'],
      );
      _items[key] = CartItem(item: item, quantity: value['quantity']);
    });
    notifyListeners();
  }
}

Future<void> saveCart() async {
  final prefs = await SharedPreferences.getInstance();
  final encoded = json.encode(_items.map((key, value) => MapEntry(
        key,
        {
          'name': value.item.name,
          'price': value.item.price,
          'image': value.item.image,
          'category': value.item.category,
          'quantity': value.quantity,
        },
      )));
  await prefs.setString('cart', encoded);
}

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
