// lib/screens/checkout_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/cart_provider.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _addressController = TextEditingController();
  List<String> _savedAddresses = [];
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadSavedAddresses();
  }

  void _loadSavedAddresses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedAddresses = prefs.getStringList('user_addresses') ?? [];
      if (_savedAddresses.isNotEmpty) {
        _addressController.text = _savedAddresses.last;
      }
    });
  }

  void _saveAddress(String address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!_savedAddresses.contains(address)) {
      _savedAddresses.add(address);
      await prefs.setStringList('user_addresses', _savedAddresses);
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _placeOrder(CartProvider cart) {
    if (_addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter delivery address')),
      );
      return;
    }

    _saveAddress(_addressController.text.trim());

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => OrderConfirmationScreen(),
      ),
    );
    cart.clearCart();
  }

  void _selectSavedAddress(String address) {
    setState(() {
      _addressController.text = address;
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Delivery Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 10),
            _isEditing
                ? Column(
                    children: [
                      TextField(
                        controller: _addressController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter your address...',
                        ),
                      ),
                      SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => setState(() => _isEditing = false),
                          child: Text('Done'),
                        ),
                      )
                    ],
                  )
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _addressController.text.isEmpty
                                  ? 'No address entered'
                                  : _addressController.text,
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                          TextButton(
                            onPressed: () => setState(() => _isEditing = true),
                            child: Text('Edit'),
                          )
                        ],
                      ),
                      if (_savedAddresses.isNotEmpty)
                        SizedBox(
                          height: 80,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: _savedAddresses.map((addr) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: ChoiceChip(
                                label: Text(addr, overflow: TextOverflow.ellipsis),
                                selected: _addressController.text == addr,
                                onSelected: (_) => _selectSavedAddress(addr),
                              ),
                            )).toList(),
                          ),
                        ),
                    ],
                  ),
            SizedBox(height: 20),
            Text('Payment Method', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ListTile(
              leading: Icon(Icons.money),
              title: Text('Cash on Delivery'),
              trailing: Icon(Icons.check_circle, color: Colors.green),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total: ₹${cart.totalPrice}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ElevatedButton(
                  onPressed: () => _placeOrder(cart),
                  child: Text('Place Order'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class OrderConfirmationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order Confirmed')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
            SizedBox(height: 20),
            Text('Your order has been placed successfully!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.popUntil(context, ModalRoute.withName('/home')),
              child: Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
