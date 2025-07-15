import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/grocery_item.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';

class GroceryItemCard extends StatelessWidget {
  final GroceryItem item;

  const GroceryItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final favProvider = Provider.of<FavoritesProvider>(context);
    final isFav = favProvider.isFavorite(item.name);
    final isInCart = cart.items.containsKey(item.name);
    final quantity = cart.items[item.name]?.quantity ?? 0;

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
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: () => favProvider.toggleFavorite(item.name),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: isInCart
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          cart.changeQuantity(item.name, -1);
                        },
                      ),
                      Text(quantity.toString(),
                          style: TextStyle(fontSize: 16)),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline),
                        onPressed: () {
                          cart.changeQuantity(item.name, 1);
                        },
                      ),
                    ],
                  )
                : ElevatedButton(
                    onPressed: () {
                      cart.addToCart(item);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('${item.name} added to cart')));
                    },
                    child: Text('Add to Cart'),
                  ),
          )
        ],
      ),
    );
  }
}
