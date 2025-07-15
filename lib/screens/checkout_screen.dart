import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/cart_provider.dart';
import 'dart:convert';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _addressController = TextEditingController();
  final _tagController = TextEditingController();
  List<Map<String, String>> _savedAddresses = [];
  bool _isEditing = false;
  String _selectedSlot = '9 AM - 11 AM';
  final List<String> _deliverySlots = [
    '9 AM - 11 AM',
    '11 AM - 1 PM',
    '1 PM - 3 PM',
    '3 PM - 5 PM',
    '5 PM - 7 PM',
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedAddresses();
  }

  void _loadSavedAddresses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? stored = prefs.getStringList('user_addresses');
    if (stored != null) {
      _savedAddresses = stored
          .map((e) => Map<String, String>.from(json.decode(e)))
          .toList();
      if (_savedAddresses.isNotEmpty) {
        _addressController.text = _savedAddresses.last['address']!;
        _tagController.text = _savedAddresses.last['tag']!;
      }
    }
    setState(() {});
  }

  void _saveAddress(String address, String tag) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> entry = {'address': address, 'tag': tag};
    if (!_savedAddresses.any((e) => e['address'] == address)) {
      _savedAddresses.add(entry);
      List<String> jsonEncoded =
          _savedAddresses.map((e) => json.encode(e)).toList();
      await prefs.setStringList('user_addresses', jsonEncoded);
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _placeOrder(CartProvider cart) {
    if (_addressController.text.trim().isEmpty || _tagController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter address and tag')),
      );
      return;
    }

    _saveAddress(_addressController.text.trim(), _tagController.text.trim());

    Navigator.pushReplacementNamed(
  context,
  '/confirmation',
  arguments: {'slot': _selectedSlot},
);
    cart.clearCart();
  }

  void _selectSavedAddress(Map<String, String> address) {
    setState(() {
      _addressController.text = address['address']!;
      _tagController.text = address['tag']!;
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
                      TextField(
                        controller: _tagController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Tag (e.g. Home, Work)',
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
                                  : '${_addressController.text} (${_tagController.text})',
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
                                label: Text('${addr['tag']}: ${addr['address']}', overflow: TextOverflow.ellipsis),
                                selected: _addressController.text == addr['address'],
                                onSelected: (_) => _selectSavedAddress(addr),
                              ),
                            )).toList(),
                          ),
                        ),
                    ],
                  ),
            SizedBox(height: 20),
            Text('Delivery Slot', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Wrap(
              spacing: 8.0,
              children: _deliverySlots.map((slot) => ChoiceChip(
                label: Text(slot),
                selected: _selectedSlot == slot,
                onSelected: (_) => setState(() => _selectedSlot = slot),
              )).toList(),
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
  final String slot;

  OrderConfirmationScreen({required this.slot});

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
            SizedBox(height: 10),
            Text('Delivery Slot: $slot'),
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
