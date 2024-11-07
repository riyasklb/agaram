import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WalletPage extends StatelessWidget {
  final String uid;

  const WalletPage({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wallet'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('agaram')
            .doc('user_delivery')
            .collection('users')
            .doc(uid)
            .collection('booking')
            .doc('wallets')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Text('No Wallet Found!'),
            );
          } else {
            final walletData = snapshot.data!;
            final currentBalance = walletData['money'];
            final transactions = walletData['transactions'] ??
                []; // Ensure transactions is not null
            final subscriptionDate = walletData['subscription'];
            final referredCount = walletData['referred'];

            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.lightGreen, Colors.greenAccent],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Balance:',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                          Text(
                            '\$$currentBalance',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            'Subscription Date:',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            '${subscriptionDate}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      print("Add Your Transaction");

                      try {
                        final TextEditingController controller =
                            TextEditingController();

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Top-up Money'),
                              content: TextField(
                                controller: controller,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    labelText: 'Enter amount to top-up'),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('Top-up'),
                                  onPressed: () async {

                                    int amount = int.tryParse(controller.text) ?? 0;

                                    // Perform top-up if amount is valid
                                    if (amount >= 10) {



                                      try{

                                        FirebaseFirestore.instance
                                            .collection('agaram')
                                            .doc('user_delivery')
                                            .collection('users')
                                            .doc(uid)
                                            .collection('booking')
                                            .doc('wallets')
                                            .snapshots();

                                        final walletData = snapshot.data!;
                                        int totalmoney = walletData['money'];
                                        List<dynamic> transactions = walletData['transactions'];
                                        transactions.add(amount);
                                        totalmoney =totalmoney+amount;
                                        print("Your Histroy : $transactions");

                                        FirebaseFirestore.instance
                                            .collection('agaram')
                                            .doc('user_delivery')
                                            .collection('users')
                                            .doc(this.uid)
                                            .collection("booking")
                                            .doc('wallets')
                                            .update({
                                          'transactions':transactions,
                                          'money':totalmoney

                                        });

                                      }
                                      catch(e){
                                        print(e);
                                      }
                                    // Close the dialog
                                    Navigator.of(context).pop();
                                    } else {
                                    // Show error message if amount is not valid
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please Enter 10 Or More')));
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } catch (e) {
                        print(e);
                      }



                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen,
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      'Top-Up',
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Recent Transactions:',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Expanded(
                    child: // Ensure transactions is not null

                        ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final transactionAmount = transactions[index];
                        return ListTile(
                          leading: Icon(Icons.monetization_on),
                          title: Text('Transaction ${index + 1}'),
                          subtitle: Text('Amount:  \u20B9${transactionAmount}'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
