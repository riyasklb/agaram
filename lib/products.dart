import 'package:flutter/material.dart';

import 'SubscriptionCard.dart';
import 'orders_calendar.dart';

class Product {
  final String name;
  final String category;
  final double price;
  final double rating; // Added rating field
  final String imageUrl; // Added image URL field
  int quantity; // Added quantity field
  final bool subs;
   bool swap;
   int times;

  Product({
    required this.times,
    required this.swap,
    required this.subs,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.imageUrl,
    this.quantity = 1, // Default quantity is 1
  });
}

class Category {
  final String name;

  Category({required this.name});
}

class ProductsPage extends StatefulWidget {
  final String uid;
  const ProductsPage({super.key, required this.uid});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<Product> selectedProducts = [];
  List<Product> subscriptionProducts = [];
  bool show_alertbox = true;

  // List to store selected products

  final List<Category> categories = [
    Category(name: 'Agaram Products'),
  ];

  final List<Product> products = [
    Product(
      times: 0,
      swap: false,
      subs: true,
      name: 'எருமை பால்',
      category: 'Agaram Products',
      price: 30,
      rating: 4.5,
      imageUrl: 'assets/products/buffalo milk.jpeg',
    ),
    Product(
      times: 0,
      swap: false,
      subs: true,
      name: 'பசும் பால்',
      category: 'Agaram Products',
      price: 39,
      rating: 4.6,
      imageUrl: 'assets/products/raw milk.jpeg',
    ),
    Product(
      times: 0,
      swap: false,
      subs: false,
      name: 'பன்னீர்',
      category: 'Agaram Products',
      price: 99,
      rating: 4.8,
      imageUrl: 'assets/products/paneer.jpeg',
    ),
    Product(
      times: 0,
      swap: false,
      subs: false,
      name: 'தயிர்',
      category: 'Agaram Products',
      price: 19,
      rating: 4.2,
      imageUrl: 'assets/products/curd.jpeg',
    ),
    Product(
      times: 0,
      swap: false,
      subs: false,
      name: 'நெய்',
      category: 'Agaram Products',
      price: 39,
      rating: 4.6,
      imageUrl: 'assets/products/cow ghee.jpeg',
    ),
    Product(
      times: 0,
      swap: false,
      subs: false,
      name: 'வெண்ணெய்',
      category: 'Agaram Products',
      price: 39,
      rating: 4.6,
      imageUrl: 'assets/products/butter.jpeg',
    ),
  ];

  @override
  bool displayfigure = true; //display default true
  int _numberOfProducts = 1; //default one

  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: categories.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildCategoryCard(categories[index]);
                    },
                  ),
                ],
              ),
            ),
          ),
          // if (selectedProducts.isEmpty &&
          //     selectedProducts.any((product) => product.quantity >=  0))
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(selectedProducts.isNotEmpty)
                ElevatedButton(
                  onPressed: () {
                    // Print selected orders
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) =>
                    //         OrdersConfirm(
                    //             products: selectedProducts, userid: widget.uid),
                    //   ),
                    // );
                  }, style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.lightGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                  child: Text(
                    "Confirm Order",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedProducts.isNotEmpty
                          ? "Selected Items:"
                          : "Select any Item",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    if(selectedProducts.isNotEmpty)
                      Text('One Time Order', style: TextStyle(
                          color: Colors.lightGreen,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.black),),
                    for (var product in selectedProducts)
                      Text('${product.name} x ${product.quantity}'),

                    const SizedBox(height: 10),
                    if(subscriptionProducts.isNotEmpty)
                      Text('Subscription Products', style: TextStyle(
                          color: Colors.lightGreen,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.black),),
                    for (var product in subscriptionProducts)
                      Text('${product.name} x ${product.times}'),
                    if(subscriptionProducts.isNotEmpty)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [ElevatedButton.icon(onPressed: () {
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(builder: (context) =>
                          //       SubscriptionGrid(uid: widget.uid,
                          //           subscriptionproducts: subscriptionProducts)),
                          //   // Prevents going back to the intro page
                          // );
                        },
                          label: Text('Add', style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold),),
                          icon: Icon(Icons.subscriptions),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.lightGreen,
                          ),
                        ), ElevatedButton.icon(onPressed: () {
                          for (var products in subscriptionProducts) {
                            if (products.swap == true) {
                              products.swap = false;
                            }
                          }
                          const snackBar = SnackBar(
                            content: Row(
                              children: [
                                Icon(Icons.close, color: Colors.red),
                                SizedBox(width: 8),
                                Text('removed!'),
                              ],
                            ),
                            backgroundColor: Colors.lightGreen,
                            duration: Duration(seconds: 0),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);


                          setState(() {
                            subscriptionProducts.clear();
                          });
                        },
                          label:
                          Icon(Icons.delete_forever_sharp),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                          ),
                        ),
                        ],)


                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _printOrders() {
    selectedProducts.forEach((product) {
      if (product.quantity > 0) {
        print('Order: ${product.name} - Quantity: ${product.quantity}');
      }
    });
  }

  Widget _buildCategoryCard(Category category) {
    List<Product> categoryProducts =
    products.where((product) => product.category == category.name).toList();

    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            child: Text(
              category.name,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Column(
            children: categoryProducts.map((Product product) {
              return _buildProductCard(product);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    bool isSelected = selectedProducts.contains(product);


    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedProducts.remove(product);
          } else {
            selectedProducts.add(product);
          }
        });
      },
      onDoubleTap: () {
        setState(() {
          selectedProducts.remove(product);
        });
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        elevation: 3,
        color: isSelected ? Colors.lightGreen : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    product.imageUrl,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                product.name,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                'Price: \u20B9 ${product.price.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 20,
                  ),
                  Text(
                    '${product.rating}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Qty:',
                    style: TextStyle(fontSize: 12),
                  ),
                  DropdownButton<int>(
                    value: product.quantity,
                    onChanged: (value) {
                      setState(() {
                        product.quantity = value!;
                      });
                    },
                    items: List.generate(20, (index) => index + 1)
                        .map((int quantity) {
                      return DropdownMenuItem<int>(
                        value: quantity,
                        child: Text(quantity.toString()),
                      );
                    }).toList(),
                    underline: Container(
                      height: 2,
                      color: Colors.black,
                    ),
                    style: const TextStyle(color: Colors.black),
                  ),
                  if(product.subs)
                    ElevatedButton.icon(onPressed: () {
                      if (show_alertbox != false) {
                        _showProductInputDialog(product);
                        setState(() {});
                        print('pass');
                      }
                      else {
                        print('fail');
                        setState(() {
                          show_alertbox = true;
                        });

                        setState(() {
                          product.swap = false;
                        });
                        print('removing');
                        subscriptionProducts.remove(product);
                        print(subscriptionProducts);
                        const snackBar = SnackBar(
                          content: Row(
                            children: [
                              Icon(Icons.close, color: Colors.red),
                              SizedBox(width: 8),
                              Text('removed!'),
                            ],
                          ),
                          backgroundColor: Colors.lightGreen,
                          duration: Duration(seconds: 0),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }

                      //
                    },
                      label: Text('Add', style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width*(0.03), fontWeight: FontWeight.bold),),
                      icon: Icon(Icons.subscriptions),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: product.swap ? Colors.lightGreen : Colors.red,
                        padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.01, // Adjust height padding
                          horizontal: MediaQuery.of(context).size.width * 0.02, // Adjust width padding
                        ),
                        textStyle: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.03, // Adjust font size based on screen width
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    ),


                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showProductInputDialog(Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double inputNumber = 1;
        return AlertDialog(
          title: Text('How many products do you want?'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Select quantity:'),
                  Slider(
                    value: inputNumber,
                    min: 1,
                    max: 20,
                    divisions: 19,
                    label: inputNumber.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        inputNumber = value;
                      });
                    },
                  ),
                  Text('Quantity: ${inputNumber.round()}'),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Submit'),
              onPressed: () {
                setState(() {
                  product.times = inputNumber.round();
                  bool isSelected = subscriptionProducts.contains(product);
                  if (isSelected) {
                    product.swap = false;
                    subscriptionProducts.remove(product);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.close, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Removed!'),
                        ],
                      ),
                      backgroundColor: Colors.lightGreen,
                      duration: Duration(seconds: 2),
                    ));
                  } else {
                    product.swap = true;
                    subscriptionProducts.add(product);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 8),
                          Text('Added!'),
                        ],
                      ),
                      backgroundColor: Colors.lightGreen,
                      duration: Duration(seconds: 2),
                    ));
                  }
                  _numberOfProducts = inputNumber.round();
                });
                Navigator.of(context).pop();

                for (var product in subscriptionProducts) {
                  print('Finally');
                  print(product.name);
                  print(product.price);
                  print(product.subs);
                  print(product.category);
                  print(product.times);

                }
              },
            ),
          ],
        );
      },
    );
  }
}