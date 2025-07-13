import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Your Cart")),
      body: cart.items.isEmpty
          ? Center(child: Text("Your cart is empty."))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items.values.toList()[index];
                      return ListTile(
                        leading: Image.network(item.item.image, width: 50, height: 50),
                        title: Text(item.item.name),
                        subtitle: Text("₹${item.item.price} x ${item.quantity}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                icon: Icon(Icons.remove_circle_outline),
                                onPressed: () =>
                                    cart.decreaseQuantity(item.item.name)),
                            IconButton(
                                icon: Icon(Icons.add_circle_outline),
                                onPressed: () =>
                                    cart.increaseQuantity(item.item.name)),
                            IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () =>
                                    cart.removeFromCart(item.item.name)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text("Total: ₹${cart.totalPrice.toStringAsFixed(2)}",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/checkout');
                        },
                        child: Text("Checkout"),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
