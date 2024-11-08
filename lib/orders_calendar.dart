import 'package:agaram_dairy/data/Payment/paymet_screen.dart';
import 'package:agaram_dairy/payment.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dashboard.dart';
import 'fulladdress.dart';



class OrdersConfirm extends StatefulWidget {
  final List<Products> products;
  final String userid;

  const OrdersConfirm({Key? key, required this.products, required this.userid}) : super(key: key);

  @override
  State<OrdersConfirm> createState() => _OrdersConfirmState();
}

class _OrdersConfirmState extends State<OrdersConfirm> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    double totalPrice = widget.products.fold(
      0,
          (previousValue, product) => previousValue + (product.p_price * product.p_quantity),
    );


    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order Lists',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green[700],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: widget.products.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.01,
                    horizontal: screenWidth * 0.05,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.products[index].p_name,
                          style: TextStyle(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Text(
                          'Price: ₹${widget.products[index].p_price.toStringAsFixed(2)} - Quantity: ${widget.products[index].p_quantity}',
                          style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.grey),
                        ),
                        if (loading)
                          const Center(child: CircularProgressIndicator(color: Colors.green)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.05),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green[50],
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Price:',
                    style: TextStyle(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    '₹$totalPrice',
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.2),

      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    RazorpayPaymentPage(price: totalPrice,confirmproduct: widget.products,authtoken: widget.userid,)),
              );              },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),

            ),

child:                      const Text(
                        'One Time',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),

            ),
          SizedBox(width: 5,),
          ElevatedButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    PaymentPage(uid: widget.userid, products: widget.products, price: totalPrice,)),
              );
              },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),

            ),

            child:                      const Text(
              'Every Time',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),

          ),


        ],

          ),
          Expanded(
            flex: 1,
            child:SingleChildScrollView( child:
            AddressCardView(uid: widget.userid),)
          ),
        ],
      ),
    );
  }
}

class AddressCardView extends StatelessWidget {
  final String uid;

  AddressCardView({required this.uid});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('agaram')
          .doc('user_delivery')
          .collection('users')
          .doc(uid)
          .collection("booking")
          .doc("full_address")
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: TextStyle(color: Colors.red),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddressPage(uid: uid)),
            );
          });
          return const Center(child: Text('No data available'));
        } else {
          Map<String, dynamic>? data = snapshot.data!.data() as Map<String, dynamic>?;
          if (data == null || data.isEmpty) {
            return Padding(
              padding: EdgeInsets.all(screenWidth * 0.03),
              child: Row(
                children: <Widget>[
                  const Text("No Address Found"),
                  const Spacer(),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text("Add Address"),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AddressPage(uid: uid)),
                      );
                    },
                  ),
                ],
              ),
            );
          }

          Map<String, dynamic> fullAddress = data['full_address'][0];

          return Card(
            margin: EdgeInsets.all(screenWidth * 0.03),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Text(
                        "Delivery Address",
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        label: const Text("Edit"),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => AddressPage(uid: uid)),
                          );
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
                    child: Text(
                      "Area: ${fullAddress['area']}\n"
                          "Pincode: ${fullAddress['pincode']}\n"
                          "City: ${fullAddress['city']}\n"
                          "House No: ${fullAddress['house_no']}\n"
                          "State: ${fullAddress['state']}",
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
