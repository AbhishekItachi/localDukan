import 'grocery_item.dart';

class CartItem {
  final GroceryItem item;
  int quantity;

  CartItem({required this.item, this.quantity = 1});
}
