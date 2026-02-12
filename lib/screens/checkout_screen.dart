import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckoutScreen extends StatefulWidget {
  final String shopName;
  final int totalAmount; 

  CheckoutScreen({required this.shopName, required this.totalAmount});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late Razorpay _razorpay;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    await FirebaseFirestore.instance.collection("orders").add({
      'name': nameController.text.trim(),
      'address': addressController.text.trim(),
      'pincode': pincodeController.text.trim(),
      'mobile': mobileController.text.trim(),
      'shop': widget.shopName,
      'amount': widget.totalAmount, 
      'paymentId': response.paymentId,
      'status': 'success',
      'timestamp': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Payment Successful! Order placed."), backgroundColor: Colors.green),
    );

    Navigator.pop(context);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Payment Failed. Try again."), backgroundColor: Colors.red),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet Selected: ${response.walletName}");
  }

  void openCheckout() {
    if (!_validateFields()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields correctly!"), backgroundColor: Colors.red),
      );
      return;
    }

    var options = {
      'key': "rzp_test_TB2gzxTwmrBAt7",  
          'amount': (widget.totalAmount * 100).round(),  
      'currency': 'INR',
      'name': widget.shopName,
      'description': 'Purchase from ${widget.shopName}',
      'prefill': {
        'contact': mobileController.text.trim(),
        'email': 'test@example.com',
      },
      'theme': {'color': '#3399cc'},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print("Error: $e");
    }
  }

  bool _validateFields() {
    return nameController.text.trim().isNotEmpty &&
           addressController.text.trim().isNotEmpty &&
           pincodeController.text.trim().length == 6 &&
           mobileController.text.trim().length == 10;
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Checkout - ${widget.shopName}")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Full Name"),
            ),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: "Address"),
            ),
            TextField(
              controller: pincodeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Pincode "),
              maxLength: 6,
            ),
            
            TextField(
              controller: mobileController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: "Mobile Number"),
              maxLength: 10,
            ),
            const SizedBox(height: 20),
            Text("Total: ₹${widget.totalAmount}.", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: openCheckout,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text("Pay Now", style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
