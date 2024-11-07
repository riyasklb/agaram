import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dashboard.dart';

class AddressPage extends StatefulWidget {
final String uid;
  const AddressPage({super.key, required this.uid});

  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController houseNoController = TextEditingController();
  final TextEditingController roadController = TextEditingController();



  bool loading= false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Address Details'),
      ),
      body: SingleChildScrollView(

        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pincode',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(

                controller: pincodeController,
                decoration: InputDecoration(
                  hintText: 'Enter Pincode',
                  prefixIcon: const Icon(Icons.location_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'City',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: cityController,
                          decoration: InputDecoration(
                            hintText: 'Enter City',
                            prefixIcon: const Icon(Icons.location_city),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'State',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: stateController,
                          decoration: InputDecoration(
                            hintText: 'Enter State',
                            prefixIcon: const Icon(Icons.location_on),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'House No. / Building Name',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: houseNoController,
                decoration: InputDecoration(
                  hintText: 'Enter House No. / Building Name',
                  prefixIcon: const Icon(Icons.home),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Road Name / Area / Colony',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: roadController,
                decoration: InputDecoration(
                  hintText: 'Enter Road Name / Area / Colony',
                  prefixIcon: const Icon(Icons.map),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,

                mainAxisAlignment: MainAxisAlignment.center,

                children: [

                 if (loading) const Center( child:CircularProgressIndicator()),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async{
      var result = await insertData();
setState(() {
  loading = true;
});
if(result)
  {
    setState(() {
      loading = false;
    });

    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) =>  HomeScreen(uid: widget.uid)));

    const snackBar = SnackBar(
      content: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.lightGreen),
          SizedBox(width: 8),
          Text('Address Stored'),
        ],
      ),
      backgroundColor: Colors.lightGreen,
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
else{


  setState(() {
    loading = false;
  });
}


        },
        label: const Text('Save Address and Continue'),
        icon: const Icon(Icons.save),
      ),
    );
  }







  Future<bool> insertData() async {

    try {

      List<Map<String, dynamic>> productsData = [];

      productsData.add({
        "pincode":pincodeController.text.trim(),
        "city":cityController.text.trim(),
        "state":stateController.text.trim(),
        "house_no":houseNoController.text.trim(),
        "area":roadController.text.trim(),
      });

      await FirebaseFirestore.instance
          .collection('agaram')
          .doc('user_delivery')
          .collection('users')
          .doc(widget.uid)
          .collection("booking")
          .doc("full_address")
          .set({
        "order_date": DateTime.now(),
        "full_address": productsData,
      });

      print("Data Inserted Successfully");
      return true;
    } catch (error) {
SnackBar(
        content: Row(
          children: [
            const Icon(Icons.close, color: Colors.red),
            const SizedBox(width: 8),
            Text('Something Went Wrong : ${error}'),
          ],
        ),
        backgroundColor: Colors.lightGreen,
        duration: const Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar as SnackBar);
      return false;
    }
  }

}
