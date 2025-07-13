import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/grocery_item.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';

class GroceryItemCard extends StatelessWidget {
  final GroceryItem item;
  final VoidCallback onAddToCart;

  const GroceryItemCard({required this.item, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    final favProvider = Provider.of<FavoritesProvider>(context);
    final isFav = favProvider.isFavorite(item.name);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Expanded(
            child: Image.network(item.image, fit: BoxFit.cover),
          ),
          ListTile(
            title: Text(item.name),
            subtitle: Text('₹${item.price}'),
            trailing: IconButton(
              icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red),
              onPressed: () => favProvider.toggleFavorite(item.name),
            ),
          ),
          ElevatedButton(
            onPressed: onAddToCart,
            child: Text('Add to Cart'),
          )
        ],
      ),
    );
  }
}
