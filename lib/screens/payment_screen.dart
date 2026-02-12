import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  final String name;
  final String phone;
  final String address;
  final String pinCode;

  const PaymentScreen({
    super.key,
    required this.name,
    required this.phone,
    required this.address,
    required this.pinCode,
  });

  void _handlePayment(String method) {
   
    print("Payment initiated via $method");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment Gateway")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Choose Payment Method:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () => _handlePayment("Google Pay"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text("Pay with Google Pay", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () => _handlePayment("PhonePe"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
              child: const Text("Pay with PhonePe", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () => _handlePayment("Razorpay"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text("Pay with Razorpay", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () => _handlePayment("Stripe"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text("Pay with Stripe", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
