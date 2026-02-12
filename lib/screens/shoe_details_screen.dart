import 'package:flutter/material.dart';
import 'cart_screen.dart'; 

class ShoeDetailsScreen extends StatefulWidget {
  final String title;
  final String imageUrl;
  final double price;
  final String offerTag;
  final List<String> sizes;

  const ShoeDetailsScreen({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.offerTag,
    required this.sizes,
  });

  @override
  State<ShoeDetailsScreen> createState() => _ShoeDetailsScreenState();
}

class _ShoeDetailsScreenState extends State<ShoeDetailsScreen> {
  List<Map<String, dynamic>> cart = [];

  void addToCart() {
    setState(() {
      cart.add({
        "title": widget.title,
        "imageUrl": widget.imageUrl,
        "price": widget.price,
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${widget.title} added to cart!"),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Details"),
       
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Center(
                    child: Image.network(
                      widget.imageUrl.isNotEmpty
                          ? widget.imageUrl
                          : "https://via.placeholder.com/150",
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "₹${widget.price}",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 55, 124, 202),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.offerTag,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Add to Cart Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: addToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Add to Cart",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
