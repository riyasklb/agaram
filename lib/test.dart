import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Product {
  String id;
  String name;
  String imageUrl;
  double price;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
  });

  factory Product.fromDocument(DocumentSnapshot doc) {
    return Product(
      id: doc['id'] ?? '',
      name: doc['name'] ?? '',
      imageUrl: doc['image_url'] ?? '',
      price: (doc['price'] ?? 0).toDouble(),
    );
  }
}

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  void _fetchProducts() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('agaram milk company')
        .doc('products')
        .collection('agaram_products')
        .get();

    List<Product> loadedProducts = querySnapshot.docs.map((doc) {
      return Product.fromDocument(doc);
    }).toList();

    setState(() {
      _products = loadedProducts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agaram Products'),
      ),
      body: _products.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return ListTile(
            leading: Image.network(product.imageUrl),
            title: Text(product.name),
            subtitle: Text('Price: ₹${product.price.toStringAsFixed(2)}'),
          );
        },
      ),
    );
  }
}
