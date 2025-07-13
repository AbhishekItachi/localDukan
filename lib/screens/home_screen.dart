import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/grocery_item.dart';
import '../widgets/grocery_item_card.dart';
import '../providers/cart_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = ['All', 'Fruits', 'Vegetables', 'Dairy', 'Bakery'];
  String _selectedCategory = 'All';

  final List<GroceryItem> _allItems = [
    GroceryItem(name: 'Tomatoes', price: 30, image: 'https://i.imgur.com/Uw8MCqy.jpg', category: 'Vegetables'),
    GroceryItem(name: 'Apples', price: 120, image: 'https://i.imgur.com/1vCj1Rf.jpg', category: 'Fruits'),
    GroceryItem(name: 'Milk', price: 60, image: 'https://i.imgur.com/L1a5g5K.jpg', category: 'Dairy'),
    GroceryItem(name: 'Bread', price: 40, image: 'https://i.imgur.com/nl68Y0p.jpg', category: 'Bakery'),
    GroceryItem(name: 'Potatoes', price: 25, image: 'https://i.imgur.com/ZC2u0CX.jpg', category: 'Vegetables'),
  ];

  List<GroceryItem> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = _allItems;
    _searchController.addListener(_filterItems);
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = _allItems.where((item) {
        final matchesSearch = item.name.toLowerCase().contains(query);
        final matchesCategory = _selectedCategory == 'All' || item.category == _selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _filterItems();
  }

  void _addToCart(GroceryItem item) {
    Provider.of<CartProvider>(context, listen: false).addToCart(item);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item.name} added to cart')),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget buildCategoryChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: _categories.map((cat) {
          final isSelected = cat == _selectedCategory;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: ChoiceChip(
              label: Text(cat),
              selected: isSelected,
              onSelected: (_) => _selectCategory(cat),
              selectedColor: Colors.green.shade200,
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GroceryGo'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
              onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search groceries...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          buildCategoryChips(),
          Expanded(
            child: _filteredItems.isNotEmpty
                ? GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredItems.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, childAspectRatio: 0.75),
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];
                      return GroceryItemCard(
                        item: item,
                        onAddToCart: () => _addToCart(item),
                      );
                    },
                  )
                : Center(child: Text("No groceries found.")),
          ),
        ],
      ),
    );
  }
}
