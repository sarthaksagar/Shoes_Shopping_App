import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _cart = [];

  List<Map<String, dynamic>> get cart => _cart;

  double get totalPrice {
    return _cart.fold(0.0, (sum, item) => sum + ((item["price"] as num) * (item["quantity"] as int)));
  }

  int get cartCount => _cart.length;

  void addToCart(Map<String, dynamic> product) {
    int index = _cart.indexWhere((item) => item["title"] == product["title"]);
    if (index != -1) {
      _cart[index]["quantity"] += 1;
    } else {
      product["quantity"] = 1;
      _cart.add(product);
    }
    notifyListeners();
  }

  void removeFromCart(int index) {
    _cart.removeAt(index);
    notifyListeners();
  }

  void increaseQuantity(int index) {
    _cart[index]["quantity"] += 1;
    notifyListeners();
  }

  void decreaseQuantity(int index) {
    if (_cart[index]["quantity"] > 1) {
      _cart[index]["quantity"] -= 1;
    } else {
      removeFromCart(index);
    }
    notifyListeners();
  }

  int calculateTotalAmount() {
    int total = _cart.fold(0, (sum, item) => sum + ((item["price"] as num).toInt() * (item["quantity"] as int)));
    return total * 100; 
  }
}
