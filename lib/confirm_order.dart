import 'package:flutter/material.dart';

import 'dashboard.dart';

class ConfirmOrderPage extends StatelessWidget {

  final String uid;
  final List<Products>confirmproduct;


  const ConfirmOrderPage({super.key, required this.uid, required this.confirmproduct});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 120.0,
              ),
              SizedBox(height: 20),
              Text(
                "Order Confirmed!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Thank you for shopping with us. Your order has been placed successfully.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 30),
              Divider(
                thickness: 1.5,
                color: Colors.grey[300],
                indent: 40,
                endIndent: 40,
              ),
              SizedBox(height: 30),
              OrderDetails(confirmproduct: confirmproduct,),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) =>HomeScreen(uid: uid)),
                        (Route<dynamic> route) => false, // Prevents going back to the intro page
                  ); },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  backgroundColor: Colors.green,
                ),
                child: Text(
                  "Continue Shopping",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderDetails extends StatelessWidget {
  final List<Products>confirmproduct;

  const OrderDetails({super.key, required this.confirmproduct});
  @override
  Widget build(BuildContext context) {

    double totalPrice = confirmproduct.fold(
      0,
          (previousValue, product) => previousValue + (product.p_price * product.p_quantity),
    );

    return Column(
      children: [
        OrderDetailRow(  
          label: "   Expected Delivery Tomorrow!",value:""),
        SizedBox(height: 10),
        OrderDetailRow(label: "Order Date:",   value: "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}"),
    
            SizedBox(height: 10),
        OrderDetailRow(label: "Payment Method:", value: "UPI via Razorpay"),
        SizedBox(height: 10),
        OrderDetailRow(label: "Total Amount:", value: totalPrice as String),
      ],
    );
  }
}

class OrderDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const OrderDetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
