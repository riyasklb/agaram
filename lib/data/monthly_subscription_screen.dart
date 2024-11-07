// import 'package:agaram_dairy/dashboard.dart';

// import 'package:agaram_dairy/sub_payment.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:table_calendar/table_calendar.dart';



// class SubscriptionGrid extends StatefulWidget {
//   final String uid;
//   final List<Products> subscriptionproducts;

//   const SubscriptionGrid({
//     super.key,
//     required this.subscriptionproducts,
//     required this.uid,
//   });

//   @override
//   State<SubscriptionGrid> createState() => _SubscriptionGridState();
// }

// class _SubscriptionGridState extends State<SubscriptionGrid> {
//   double totalprice = 0;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.subscriptionproducts.isNotEmpty) {
//       gettingtotalprice(widget.subscriptionproducts);
//     }
//   }

//   Future<void> gettingtotalprice(List<Products> list) async {
//     for (var product in list) {
//       totalprice += product.p_quantity * product.p_price;
//     }
//     print("Total Price Is $totalprice");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Subscription Plans'),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => SubscriptionDetailsScreen(
//                   products: widget.subscriptionproducts,
//                   uid: widget.uid,
//                   price: totalprice,
//                 ),
//               ),
//             );
//           },
//           child: Text("View Subscription Details"),
//         ),
//       ),
//     );
//   }
// }

// class SubscriptionDetailsScreen extends StatelessWidget {
//   final List<Products> products;
//   final String uid;
//   final double price;

//   const SubscriptionDetailsScreen({
//     super.key,
//     required this.products,
//     required this.uid,
//     required this.price,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Subscription Details'),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'User ID: $uid',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Total Price: ₹$price',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Products:',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: products.length,
//                 itemBuilder: (context, index) {
//                   final product = products[index];
//                   return ListTile(
//                     title: Text(product.p_name),
//                     subtitle: Text('Quantity: ${product.p_quantity}'),
//                     trailing: Text('Price: ₹${product.p_price}'),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
