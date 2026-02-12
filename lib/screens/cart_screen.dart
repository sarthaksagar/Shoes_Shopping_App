import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:footware_page/controller/cart_provider.dart';
import 'package:footware_page/screens/checkout_screen.dart';

class CartScreen extends StatelessWidget {
     CartScreen({super.key, required List cart}); // Remove required List cart

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cart = cartProvider.cart;
    double totalPrice = cartProvider.totalPrice;

    return Scaffold(
      appBar: AppBar(title: const Text("Your Cart")),
      body: cart.isEmpty
          ? const Center(child: Text("Cart is empty"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final item = cart[index];
                      return ListTile(
                        leading: Image.network(item["imageUrl"], width: 50),
                        title: Text(item["title"]),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("₹${item["price"]}"),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle),
                                  onPressed: () => cartProvider.decreaseQuantity(index),
                                ),
                                Text("${item["quantity"]}"),
                                IconButton(
                                  icon: const Icon(Icons.add_circle),
                                  onPressed: () => cartProvider.increaseQuantity(index),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Remove Item"),
                                  content: Text("Remove ${item["title"]} from cart?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        cartProvider.removeFromCart(index);
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text("${item["title"]} removed!"),
                                            duration: const Duration(seconds: 2),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      },
                                      child: const Text("Delete", style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text("Total: ₹$totalPrice", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: cart.isNotEmpty
                            ? () {
                                int totalAmount = cartProvider.calculateTotalAmount();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CheckoutScreen(shopName: "Shop's", totalAmount: totalPrice.toInt()),

                                  ),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        child: const Text(
                          "Proceed to Checkout",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
} 