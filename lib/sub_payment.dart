import 'package:agaram_dairy/confirm_order.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'dashboard.dart';

class SubRazorpayPaymentPage extends StatefulWidget {
  @override
  _SubRazorpayPaymentPage createState() => _SubRazorpayPaymentPage();

  // final List<Products> confirmproduct;
  final String authtoken;
  final double price;

  const SubRazorpayPaymentPage({super.key, required this.price, required this.authtoken});
}

class _SubRazorpayPaymentPage extends State<SubRazorpayPaymentPage> {
  late Razorpay _razorpay;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _startPayment() {
    var options = {
      'key': 'rzp_test_wKYekqKvgG4n9n',
      'amount': widget.price * 100, // Amount in paise (50000 paise = ₹500)
      'name': 'Agaram',
      'description': 'Order Payment',
      'prefill': {
        'contact': '9087356083',
        'email': 'test@example.com',
      },
      'upi': {
        'vpa': 'ramdeveloper2005@okicici', // UPI ID
      },
      'external': {
        'wallets': ['paytm', 'gpay', 'phonepe'],
      }
    };

    try {
      setState(() => _isProcessing = true);
      _razorpay.open(options);
    } catch (e) {
      setState(() => _isProcessing = false);
      debugPrint("Error: $e");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    setState(() => _isProcessing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Successful: ${response.paymentId}")),
    );
    // Navigator.of(context).pushAndRemoveUntil(
    //   MaterialPageRoute(builder: (context) => ConfirmOrderPage(uid: widget.authtoken, confirmproduct: widget.confirmproduct)),
    //       (Route<dynamic> route) => false,
    // );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() => _isProcessing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Failed: ${response.message}")),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    setState(() => _isProcessing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("External Wallet: ${response.walletName}")),
    );
  }

  @override
  Widget build(BuildContext context) {
    // double totalPrice = widget.confirmproduct.fold(0, (total, product) => total + (product.p_price * product.p_quantity));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Summary & Payment',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.white,),),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Order Summary",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: widget.confirmproduct.length,
            //     itemBuilder: (context, index) {
            //       final product = widget.confirmproduct[index];
            //       return ListTile(
            //         leading: Image.network(product.p_imageUrl, width: 50, height: 50, fit: BoxFit.cover),
            //         title: Text(product.p_name, style: const TextStyle(fontWeight: FontWeight.bold)),
            //         subtitle: Text("Quantity: ${product.p_quantity}"),
            //         trailing: Text("₹${(product.p_price * product.p_quantity).toStringAsFixed(2)}"),
            //       );
            //     },
            //   ),
            // ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total Price:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("₹${widget.price}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: _isProcessing
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _startPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text('Pay Now',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight:FontWeight.bold),),

              ),
            ),
          ],
        ),
      ),
    );
  }
}
