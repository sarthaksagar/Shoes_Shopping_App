import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:footware_page/controller/cart_provider.dart';
import 'package:provider/provider.dart';

import '../screens/cart_screen.dart';

class ProductDescriptionPage extends StatefulWidget {
  final String title;
  final String imageUrl;
  final double price;
  final String offerTag;
  final List<String> sizes;

  const ProductDescriptionPage({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.offerTag,
    required this.sizes,
  });

  @override
  State<ProductDescriptionPage> createState() => _ProductDescriptionPageState();
}

class _ProductDescriptionPageState extends State<ProductDescriptionPage> {
  void addToCart() {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.addToCart({
      "title": widget.title,
      "imageUrl": widget.imageUrl,
      "price": widget.price,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${widget.title} added to cart!"),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.greenAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Product Details",
          style: TextStyle(
            color: Color.fromARGB(255, 102, 7, 255),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              return badges.Badge(
                position: badges.BadgePosition.topEnd(top: 0, end: 3),
                badgeAnimation: const badges.BadgeAnimation.scale(),
                showBadge: cartProvider.cart.isNotEmpty,
                badgeContent: Text(
                  cartProvider.cart.length.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartScreen(cart: []),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
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
