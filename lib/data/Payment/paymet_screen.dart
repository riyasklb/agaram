import 'package:agaram_dairy/dashboard.dart';
import 'package:agaram_dairy/data/Payment/controller.dart';
import 'package:agaram_dairy/data/Payment/sucess_full_screen.dart';
import 'package:agaram_dairy/data/contats/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentPage extends StatefulWidget {
  final List<Products> products;
  final String uid;
  final double price;

  PaymentPage({
    Key? key,
    required this.products,
    required this.uid,
    required this.price, 
  }) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late Razorpay razorpay;
  final AuthController authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
  }

  @override
  void dispose() {
    razorpay.clear(); // Dispose of Razorpay to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kblue,
        title: Text(
          'Payment',
          style: GoogleFonts.lato(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Amount to Pay:',
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              '₹${widget.price.toStringAsFixed(2)}', // Dynamic amount
              style: GoogleFonts.poppins(
                fontSize: 36.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40.h),
            ElevatedButton(
              onPressed: openPaymentGateway,
              style: ElevatedButton.styleFrom(
                backgroundColor: kblue,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'Pay Now',
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Open Razorpay Payment Gateway
  void openPaymentGateway() {
    var options = {
      'key': 'rzp_test_sWnFHSJbOds7ZX',
      'amount': (widget.price * 100).toInt(), // Amount in paise
      'name': 'Acme Corp.',
      'description': 'Fine T-Shirt',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '9633749714', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };
    razorpay.open(options);
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) async {
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, now.day);
    final endDate = now.add(Duration(days: 30)); // 30 days subscription

    try {
      // Store payment details in Firestore
      await FirebaseFirestore.instance
          .collection('agaram')
          .doc('user_delivery')
          .collection('users')
          .doc(widget.uid)
          .set({
        'subscription': {
          'total_price': widget.price,
          'start_date': startDate,
          'end_date': endDate,
          'products': widget.products
              .map((product) => {
                    'name': product.p_name,
                    'quantity': product.p_quantity,
                    'price': product.p_price,
                    'start_date': startDate,
                    'end_date': endDate,
                  })
              .toList(),
        },
      }, SetOptions(merge: true));

      authController.showToast(
        context,
        text: 'Payment Successful\nPayment ID: ${response.paymentId}',
        icon: Icons.check,
      );

      // Navigate to Dashboard or ReferralScreen after payment success
      Get.offAll(() => PaymentSuccessScreen(paymentId: response.paymentId.toString(),));
    } catch (e) {
      print('Error storing payment details: $e');
      showAlertDialog(context, "Error", "Failed to store payment details.");
    }
  }

  // Handle Payment Error
  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    authController.showToast(
      context,
      text: 'Payment Failed',
      icon: Icons.error,
    );
    showAlertDialog(
      context,
      "Payment Failed",
      "Code: ${response.code}\nDescription: ${response.message}\nMetadata: ${response.error.toString()}",
    );
  }

  // Handle External Wallet Selection
  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(
        context, "External Wallet Selected", "${response.walletName}");
  }

  // Show Alert Dialog
  void showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            ElevatedButton(
              child: const Text("Continue"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
