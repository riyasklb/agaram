import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductListScreen extends StatelessWidget {
  final DocumentSnapshot productDocument;

  ProductListScreen({required this.productDocument});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: ListView.builder(
        itemCount: productDocument['items'].length,
        itemBuilder: (context, index) {
          Map<String, dynamic> product = productDocument['items'][index];
          return ListTile(
            title: Text(product['name']),
            subtitle: Text('Price: ${product['price']}, Quantity: ${product['quantity']}'),
          );
        },
      ),
    );
  }
}
