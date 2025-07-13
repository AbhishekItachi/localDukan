import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider with ChangeNotifier {
  Set<String> _favorites = {};

  Set<String> get favorites => _favorites;

  void toggleFavorite(String itemName) {
    if (_favorites.contains(itemName)) {
      _favorites.remove(itemName);
    } else {
      _favorites.add(itemName);
    }
    notifyListeners();
    saveFavorites();
  }

  bool isFavorite(String itemName) => _favorites.contains(itemName);

  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favorites', _favorites.toList());
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    _favorites = prefs.getStringList('favorites')?.toSet() ?? {};
    notifyListeners();
  }
}