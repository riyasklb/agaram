import 'dart:convert';

import 'package:agaram_dairy/payment_gateway.dart';
import 'package:agaram_dairy/products.dart';
import 'package:agaram_dairy/sub_payment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard.dart';

// class SubscriptionGrid extends StatefulWidget {

//   final String uid;
//  final List<Products> subscriptionproducts;
//   const SubscriptionGrid(
//       {super.key,
//       required this.subscriptionproducts,
//       required this.uid,});


//   @override
//   State<SubscriptionGrid> createState() => _SubscriptionGridState();
// }



// class _SubscriptionGridState extends State<SubscriptionGrid> {

//   double totalprice=0;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     if(widget.subscriptionproducts.isNotEmpty)
//       {
//         gettingtotalprice(widget.subscriptionproducts);
//         // saveSession(widget.subscriptionproducts);
//         print('done');
//       }
//   }


// //   Future<bool> saveSession(List<Product> items) async {
// //     final prefs = await SharedPreferences.getInstance();
// //
// //     for(var item in items)
// //       {
// //         prefs.setString(item.name, item.name);
// //         prefs.setDouble(item.price as String, item.price);
// //         prefs.setInt(item.times as String,item.times);
// //       }
// // print("Cached Are Stored");
// // return true;
// //   }



//     // Future<bool> insertSubscription() async {
//     //   try {
//     //     final subscriptionDetailsDoc = FirebaseFirestore.instance
//     //         .collection('agaram')
//     //         .doc('user_delivery')
//     //         .collection('users')
//     //         .doc(widget.uid)
//     //         .collection("booking")
//     //         .doc('subscriptions_details');
//     //
//     //     List<Map<String, dynamic>> subscriptionList = [];
//     //
//     //     for (var item in widget.subscriptionproducts) {
//     //       subscriptionList.add({
//     //         'subscription_issued': item.name,
//     //         'price': item.price,
//     //         'times': item.times,
//     //         'category': item.category,
//     //         'subs': item.subs,
//     //         'imageUrl': item.imageUrl,
//     //                 });
//     //     }
//     //
//     //     await subscriptionDetailsDoc.set({
//     //       'subscriptions': subscriptionList,
//     //       'issued': false
//     //     });
//     //
//     //   return true;
//     //   } catch (e) {
//     //     print(e);
//     //     return false;
//     //   }
//     // }



//   Future<void> gettingtotalprice(List<Products> list)
//   async {
//     print("Im Acessing gettingtotalprice()");
//     int temp;
//     for (var product in list) {
//       this.totalprice += product.p_quantity * product.p_price;
//       print('totalprice= ${product.p_quantity}  ${product.p_price}');
//     }

//     // var result = await insertSubscription();
//     // print(result? "pass":"failed");
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
//       body: LayoutBuilder(
//         builder: (context, constraints) {



//           if (constraints.maxWidth > 600) {
//             // Wide screen layout
//             return WideScreenLayout(products: widget.subscriptionproducts,uid: widget.uid, price: totalprice);
//           } else {
//             // Narrow screen layout
//             return NarrowScreenLayout(product:widget.subscriptionproducts,uid: widget.uid, price: totalprice);
//           }
//         },
//       ),
//     );
//   }
// }

class WideScreenLayout extends StatelessWidget {
  final String uid;
  final double price;
  final List<Products> products;
  const WideScreenLayout({super.key,required this.products,required this.price, required this.uid});
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 10.0,
      mainAxisSpacing: 10.0,
      padding: EdgeInsets.all(10.0),
      children: [
        Text(
          'Selected Subscription Product',
          style:  TextStyle(
            fontSize: 14,
            // backgroundColor: Colors.greenAccent,
            fontWeight: FontWeight.normal,
            fontFamily: "Nunito Sans",
          ),textAlign: TextAlign.center,
        ),
        for(var item in this.products)
          Text(
            '${item.p_name}',
            style:  TextStyle(
              fontSize: 14,
              backgroundColor: Colors.greenAccent,
              fontWeight: FontWeight.normal,
              fontFamily: "Nunito Sans",
            ),textAlign: TextAlign.center,
          ),
        SubscriptionCard(
          uid: uid,
          title: 'Alternative Days',
          description: 'We Can Provide Products For Alternative Days',
          price: price,
          duration: 'Alternative Days',
          subscriptionType: SubscriptionType.AlternativeDays,
        ),
        SubscriptionCard(
          uid: uid,
          title: 'Weekly Packages',
          description: 'We Can Provide Our Products For Weekly',
          price: price * 7,
          duration: 'Yearly',
          subscriptionType: SubscriptionType.Weekly,
        ),
        SubscriptionCard(
          uid: uid,
          title: 'Monthly Package',
          description: 'We Can Provide Our Products For Every Months',
          price: price * 30,
          duration: 'Monthly',
          subscriptionType: SubscriptionType.Monthly,
        ),
        // Add more SubscriptionCard widgets here as needed
      ],
    );
  }
}

class NarrowScreenLayout extends StatefulWidget {
  final String uid;
  final double price;
  final List<Products> product;
  const NarrowScreenLayout({super.key,required this.product, required this.price, required this.uid});
  @override
  State<NarrowScreenLayout> createState() => _NarrowScreenLayoutState();
}

class _NarrowScreenLayoutState extends State<NarrowScreenLayout> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(10.0),
      children: [
        Text(
          'Selected Subscription Product',
          style:  TextStyle(
            fontSize: 14,
            // backgroundColor: Colors.greenAccent,
            fontWeight: FontWeight.normal,
            fontFamily: "Nunito Sans",
          ),textAlign: TextAlign.center,
        ),
        for(var item in widget.product)
        Text(
          '${item.p_name}',
          style:  TextStyle(
            fontSize: 14,
            backgroundColor: Colors.greenAccent,
            fontWeight: FontWeight.normal,
            fontFamily: "Nunito Sans",
          ),textAlign: TextAlign.center,
        ),
        SubscriptionCard(
          uid: widget.uid,
          title: 'Alternative Days',
          description: 'We Can Provide Products For Alternative Days',
          price: widget.price,
          duration: 'Alternative Days',
          subscriptionType: SubscriptionType.AlternativeDays,
        ),
        SubscriptionCard(
          uid: widget.uid,
          title: 'Weekly Packages',
          description: 'We Can Provide Our Products For Weekly',
          price: widget.price * 7,
          duration: 'Yearly',
          subscriptionType: SubscriptionType.Weekly,
        ),
        SubscriptionCard(
          uid: widget.uid,
          title: 'Monthly Package',
          description: 'We Can Provide Our Products For Every Month',
          price: widget.price * 30, // Pass the calculated price as a double
          duration: 'Monthly',
          subscriptionType: SubscriptionType.Monthly,
        ),


        // Add more SubscriptionCard widgets here as needed
      ],
    );
  }
}

enum SubscriptionType {
  AlternativeDays,
  Monthly,
  Weekly,
}

class SubscriptionCard extends StatefulWidget {
  final String title;
  final String description;
  final double price;
  final String duration;
  final SubscriptionType subscriptionType;
  final String uid;

  const SubscriptionCard({
    required this.uid,
    required this.title,
    required this.description,
    required this.price,
    required this.duration,
    required this.subscriptionType,
  });

  @override
  State<SubscriptionCard> createState() => _SubscriptionCardState();
}

class _SubscriptionCardState extends State<SubscriptionCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showSubscriptionDialog(context);
      },
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                widget.description,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\u{20B9}${widget.price}', // Indian currency symbol
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
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

  void _showSubscriptionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        switch (widget.subscriptionType) {
          case SubscriptionType.AlternativeDays:
            return _buildAlternativeDaysDialog(context,widget.price, widget.uid);
          case SubscriptionType.Monthly:
            return _buildMonthlyDialog(context,widget.price,widget.uid);
          case SubscriptionType.Weekly:
            return _buildWeeklyDialog(context,widget.price, widget.uid);
        }
      },
    );
  }

  Widget _buildMonthlyDialog(BuildContext context,double price, String uid) {
    final String userid = uid;
    DateTime now = DateTime.now();
    DateTime startDate = DateTime(now.year, now.month,
        now.day + 1); // Start date as 15th of the current month
    DateTime endDate = DateTime(now.year, now.month,
        now.day + 31); // End date as 15th of the next month

    return AlertDialog(
      title: Text('Select Subscription Period'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Selected Period:'),
          SizedBox(height: 20.0),
          Text(
            'Start Date: ${DateFormat('dd-MM-yyyy').format(startDate)}',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10.0),
          Text(
            'End Date: ${DateFormat('dd-MM-yyyy').format(endDate)}',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Add functionality to proceed with subscription
            print('Start Date: ${DateFormat('dd-MM-yyyy').format(startDate)}');
            print('End Date: ${DateFormat('dd-MM-yyyy').format(endDate)}');
            // Navigate to the transaction page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TransactionPage(
                  amount: price,
                  startDate: startDate,
                  endDate: endDate,
                  uid: userid,
                ),
              ),
            );
          },
          child: Text('Subscribe'),
        ),
      ],
    );
  }

  Widget _buildYearSelector(
      BuildContext context, int selectedYear, Function(int) onChanged) {
    final List<int> years =
        List.generate(11, (index) => DateTime.now().year + index);

    return DropdownButton<int>(
      value: selectedYear,
      onChanged: (int? value) {
        // Call the callback function to update the selected year in the parent widget's state
        onChanged(value!);
        // Print the selected year
        print('Selected Year: $value');
      },
      items: years.map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
    );
  }

  Widget _buildWeeklyDialog(BuildContext context,double price,  String uid) {
    final String userid = uid;
    DateTime selectedMonth = DateTime.now();
    int selectedWeek = 1; // Initialize selected week

    return AlertDialog(
      title: Text('Select Subscription Periods'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Select the month:'),
          SizedBox(height: 10.0),
          ElevatedButton(
            onPressed: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now().add(Duration(
                    days: 1)), // Ensure initialDate is not before firstDate
                firstDate: DateTime.now().add(Duration(
                    days: 1)), // Only allow future dates starting from tomorrow
                lastDate: DateTime.now().add(Duration(days: 365)),
              );
              if (picked != null && picked != selectedMonth) {
                setState(() {
                  selectedMonth = picked; // Update the selectedMonth variable
                });
              }
            },
            child: Text(
              DateFormat('MMMM yyyy').format(selectedMonth),
              style: TextStyle(fontSize: 15),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
          SizedBox(height: 20.0),

        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Perform any action with the selected month and week here
            // For simplicity, let's print the selected month and week
            print(
                'Selected Month: ${DateFormat('MMMM').format(selectedMonth)}');
            print('Selected Week: $selectedWeek');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TransactionPages(
                  uid: userid,
                  amount:price,
                  selectedYear: selectedMonth.year,
                  selectedMonth: selectedMonth.month,
                  selectedWeek: selectedWeek,
                  selectedays: selectedMonth.day+7,
                ),
              ),
            );
          },
          child: Text('Subscribe'),
        ),
      ],
    );
  }
}


class MultiDayPicker extends StatefulWidget {
  final Function(List<DateTime>) onSelectedDatesChanged;

  const MultiDayPicker({Key? key, required this.onSelectedDatesChanged}) : super(key: key);

  @override
  _MultiDayPickerState createState() => _MultiDayPickerState();
}

class _MultiDayPickerState extends State<MultiDayPicker> {
  List<DateTime> _selectedDates = [];
  late DateTime _firstDate;
  late DateTime _lastDate;
  bool _showMonthPage = false;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    _firstDate = DateTime(now.year, now.month, now.day + 1);
    _lastDate = DateTime.now().add(Duration(days: 365));
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return SizedBox(
      height: 250, // Set a smaller height
      width: 300,  // Set a smaller width
      child: TableCalendar(
        firstDay: _firstDate,
        lastDay: _lastDate,
        focusedDay: DateTime(now.year, now.month, now.day + 1),
        selectedDayPredicate: (day) {
          return _selectedDates.contains(day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            if (_selectedDates.contains(selectedDay)) {
              _selectedDates.remove(selectedDay);
              _showMonthPage = true; // Show the month page when deselecting a day
            } else {
              _selectedDates.add(selectedDay);
              _showMonthPage = false; // Stay on the same month page when selecting a day
            }
          });
          // Call the callback function to pass selected dates to the parent widget
          widget.onSelectedDatesChanged(_selectedDates);
        },
        onPageChanged: (focusedDay) {
          if (_showMonthPage) {
            setState(() {
              _showMonthPage = false; // Reset the flag when the month page changes
            });
          }
        },
      ),
    );
  }
}
Widget _buildAlternativeDaysDialog(BuildContext context, double price, String uid) {
  final String userid = uid;
  List<String> selectedDates = []; // Store dates as strings in 'YYYY-MM-DD' format
  DateTime focusedDay = DateTime.now();
  // double amount = price * selectedDates.length;



  return Dialog(
    child: Container(
      height: MediaQuery.of(context).size.height * 0.9,
      width: MediaQuery.of(context).size.width * 0.8,
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            child: Column(
              children: [
                TableCalendar(
                  focusedDay: focusedDay,
                  firstDay: DateTime.now().subtract(Duration(days: 365)),
                  lastDay: DateTime.now().add(Duration(days: 365)),
                  calendarFormat: CalendarFormat.month,
                  selectedDayPredicate: (day) => selectedDates.contains(_formatDate(day)),
                  onDaySelected: (selectedDay, newFocusedDay) {
                    setState(() {
                      focusedDay = newFocusedDay;
                      String formattedDate = _formatDate(selectedDay);

                      if (selectedDates.contains(formattedDate)) {
                        selectedDates.remove(formattedDate);
                      } else {
                        selectedDates.add(formattedDate);
                      }

                      print("Selected Dates : $selectedDates");
                    });
                  },
                  onPageChanged: (newFocusedDay) {
                    setState(() {
                      focusedDay = newFocusedDay;
                    });
                  },
                  // Disable past dates
                  enabledDayPredicate: (day) {
                    return day.isAfter(DateTime.now().subtract(Duration(days: 1))); // Enable only future dates
                  },
                ),


                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubscriptionPage(
                              total_amount: price * selectedDates.length,
                              selectedDates: selectedDates,
                              uid: userid,
                            ),
                          ),
                        );
                        print("Selected Dates : ${selectedDates}");
                      },
                      child: Text('Subscribe'),
                    ),

                  ],
                )
              ],
            ),
          );
        },
      ),
    ),
  );
}



/*
Widget _buildAlternativeDaysDialog(BuildContext context, double price, String uid) {
  final String userid = uid;
  List<DateTime> selectedDates = [];
  double amount = 0;

  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Subscription Periods',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9, // Slightly reduced width
              height: MediaQuery.of(context).size.height * 0.4, // Fixed height
              child: TableCalendar(
                focusedDay: DateTime.now(),
                firstDay: DateTime.now().subtract(Duration(days: 365)),
                lastDay: DateTime.now().add(Duration(days: 365)),
                calendarFormat: CalendarFormat.month,
                selectedDayPredicate: (day) => selectedDates.contains(day),
                onDaySelected: (selectedDay, focusedDay) {
                  if (selectedDates.contains(selectedDay)) {
                    selectedDates.remove(selectedDay);
                  } else {
                    selectedDates.add(selectedDay);
                  }
                },
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    List<String> formattedDates = selectedDates.map((date) => _formatDate(date)).toList();
                    print('Selected dates: $formattedDates');
                    amount = price * selectedDates.length;
                    print("Total Amount of Subscription: $amount");

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubscriptionPage(
                          total_amount: amount,
                          selectedDates: selectedDates,
                          uid: userid,
                        ),
                      ),
                    );
                  },
                  child: Text('Subscribe'),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

*/

// Helper function to format date
String _formatDate(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

class SubscriptionPage extends StatelessWidget {
  final List<String> selectedDates;
  final String uid;
  final double total_amount;

  SubscriptionPage({required this.selectedDates, required this.total_amount, required this.uid});

  @override
  Widget build(BuildContext context) {

      return Scaffold(
        appBar: AppBar(
          title: Text('Subscription Page'),

        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0), // Add padding around the body
          child: Center( 
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Selected Dates:',
                  style: TextStyle(
                    fontSize: 24, // Larger font for better visibility
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16), // Space between title and dates
                Expanded(
                  child: ListView(
                    children: selectedDates.map((date) {
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 4), // Space between cards
                        child: Padding(
                          padding: const EdgeInsets.all(8.0), // Padding inside the card
                          child: Text(
                            date,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 16), // Space between dates and total amount
                Text(
                  "Total Amount: \₹${total_amount.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 22, // Larger font for total amount
                    fontWeight: FontWeight.bold,
                    color: Colors.green, // Color for visibility
                  ),
                ),
                SizedBox(height: 16), // Space before button
                ElevatedButton(
                  onPressed: () {
                    // Format all selected dates before proceeding with the transaction
                    List<String> formattedDates = selectedDates.map((date) => date).toList();

                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SubRazorpayPaymentPage(price: total_amount, authtoken: this.uid,)),
                    );

                  },
                  child: Text('Proceed with Transaction',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight:FontWeight.bold),),
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Button padding
                      textStyle: TextStyle(fontSize: 18), // Button text size
                      backgroundColor: Colors.blueAccent, // Button color
                      overlayColor: Colors.white
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }



  showAlertDialog(BuildContext context, String message) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => HomeScreen(uid:this.uid )),
              // (Route<dynamic> route) => false, // Prevents going back to the intro page
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void performTransaction(List<String> formattedDates) {
    Subscription_Active_fordates todo = Subscription_Active_fordates(
        active_date: formattedDates, uid: this.uid,total_price: this.total_amount);
    todo.insertData();

    print('Performing transaction for dates: $formattedDates');
  }

  String _formatDate(DateTime date) {
    // Format the date to display only the date component without the time
    return DateFormat('yyyy-MM-dd').format(date);
  }
}



class TransactionPage extends StatelessWidget {
  final String uid;
  final DateTime startDate;
  final DateTime endDate;
  final double amount;

  TransactionPage({
    required this.startDate,
    required this.amount,
    required this.uid,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Page'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding around the body
        child: Center(
          child: Card(
            elevation: 8, // Adds shadow to the card for depth
            child: Padding(
              padding: const EdgeInsets.all(20.0), // Padding inside the card
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Transaction Summary',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16), // Space between title and first text
                  ListTile(
                    leading: Icon(Icons.date_range, color: Colors.blueAccent),
                    title: Text('Start Month: ${DateFormat('yyyy-MM-dd').format(startDate)}'),
                  ),
                  ListTile(
                    leading: Icon(Icons.date_range, color: Colors.redAccent),
                    title: Text('End Month: ${DateFormat('yyyy-MM-dd').format(endDate)}'),
                  ),
                  SizedBox(height: 16), // Space before amount
                  Text(
                    "30 Days Subscription Total Amount: \₹${amount.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 20), // Space before button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SubRazorpayPaymentPage(
                            price: amount,
                            authtoken: this.uid,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Proceed with Transaction',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Rounded corners
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  showAlertDialog(BuildContext context, String message) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        // Navigator.of(context).push(
        //   MaterialPageRoute(builder: (context) => Dashboard(uid: this.uid)),
        //   // (Route<dynamic> route) =>
        //   //     false, // Prevents going back to the intro page
        // );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void performTransaction(String startDate, String endDate) {
    List<String> datesinmonth =
        displayDatesInMonth(DateTime.parse(startDate), DateTime.parse(endDate));

    Subscription_Active todo =
        Subscription_Active(total_price: this.amount,start_date: datesinmonth, uid: this.uid);
    todo.insertData();
    // print('Performing transaction for start date: ${formattedDates[0]} and end date: ${formattedDates[1]}');

    // Display all dates in the selected month
  }

  List<String> displayDatesInMonth(DateTime startDate, DateTime endDate) {
    List<String> datesInMonth = [];

    // Add dates for the start month
    int year = startDate.year;
    int month = startDate.month;
    int daysInMonth = DateTime(year, month + 1, 0)
        .day; // Get the number of days in the start month
    int startDay = startDate.day;

    for (int i = startDay; i <= daysInMonth; i++) {
      DateTime currentDate = DateTime(year, month, i);
      String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
      datesInMonth.add(formattedDate);
    }

    // If end date falls in the next month, add remaining days of the end month
    if (startDate.month != endDate.month) {
      year = endDate.year;
      month = endDate.month;
      int endDay = endDate.day;

      for (int i = 1; i <= endDay; i++) {
        DateTime currentDate = DateTime(year, month, i);
        String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
        datesInMonth.add(formattedDate);
      }
    }

    // Display the dates
    for (String date in datesInMonth) {
      print(date);
    }

    return datesInMonth;
  }

  String formattedDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // void performTransaction(String startDate, String endDate) {
  //
  //   List<String> formattedDates = [startDate,endDate];
  //
  //   Subscription_Active todo = Subscription_Active(start_date:startDate, end_date:  endDate, uid: this.uid);
  //   todo.insertData();
  //   print('Performing transaction for start month: ${formattedDates[0]} and end month: ${formattedDates[1]}');
  // }

  //
  // String formattedDates(DateTime date) {
  //   // Format the date to display only the date component without the time
  //   return DateFormat('yyyy-MM-dd').format(date);
  // }
}
class TransactionPages extends StatelessWidget {
  final int selectedYear;
  final int selectedMonth; // Add selectedMonth parameter
  final int selectedWeek; // Add selectedWeek parameter
  final int selectedays; // Add selectedWeek parameter

  final String uid;
  final double amount;

  TransactionPages({
    required this.amount,
    required this.selectedYear,
    required this.selectedMonth,
    required this.selectedWeek,
    required this.selectedays,

    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Page'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding around the body
        child: Center(
          child: Card(
            elevation: 8, // Shadow for the card
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Rounded corners
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0), // Padding inside the card
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Selected Year: $selectedYear',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8), // Space between texts
                  Text(
                    'Selected Month: ${DateFormat('yyyy-MM-dd').format(DateTime(selectedYear, selectedMonth))}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8), // Space between texts
                  Text(
                    'Selected Week: $selectedWeek',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 16), // Space before amount
                  Text(
                    '7-Day Subscription Total Amount: \₹${amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 20), // Space before button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SubRazorpayPaymentPage(
                            price: amount,
                            authtoken: this.uid,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Proceed with Transaction',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Button padding
                      backgroundColor: Colors.blueAccent, // Button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Rounded corners
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

//
//   void performTransaction(int selectedYear, int selectedMonth, int selectedWeek) {
//     // Construct the selected date based on the selected year, month, and week
//     DateTime firstDayOfMonth = DateTime(selectedYear, selectedMonth, 1);
//     int daysInMonth = DateTime(selectedYear, selectedMonth + 1, 0).day;
//     DateTime firstDayOfWeek = firstDayOfMonth.add(Duration(days: (selectedWeek - 1) * 7));
//     DateTime lastDayOfWeek = firstDayOfWeek.add(Duration(days: 6)); // Add 6 days to get the end of the week
//
//     // Format the dates
//     String formattedStartDate = DateFormat('yyyy-MM-dd').format(firstDayOfWeek);
//
//
//     Subscription_Active todo = Subscription_Active(start_date: formattedStartDate , uid: this.uid);
//     todo.insertData();
//     print('Performing transaction for year: $selectedYear, month: $selectedMonth, and week: $selectedWeek');
//   }
// }
  void performTransaction(
      int selectedYear, int selectedMonth, int selectedWeek,int selectedays) {
    // Calculate the first and last days of the selected week
    DateTime firstDayOfMonth = DateTime(selectedYear, selectedMonth, selectedays-6);
    DateTime firstDayOfWeek =
        firstDayOfMonth.add(Duration(days: (selectedWeek - 1) * 7));
    DateTime lastDayOfWeek = firstDayOfWeek.add(Duration(days: 6));

    // Format the dates
    String formattedStartDate = DateFormat('yyyy-MM-dd').format(firstDayOfWeek);
    String formattedEndDate = DateFormat('yyyy-MM-dd').format(lastDayOfWeek);

    List<String> datesInWeek = displayDatesInWeek(firstDayOfWeek);

    // Create an instance of Subscription_Active with the formatted dates and UID
    Subscription_Active todo =
        Subscription_Active(total_price:this.amount,start_date: datesInWeek, uid: this.uid);
    todo.insertData(); // Insert data

    print(
        'Performing transaction for start date: $formattedStartDate and end date: $formattedEndDate');
  }

  List<String> displayDatesInWeek(DateTime startOfWeek) {
    List<String> datesInWeek = [];

    for (int i = 0; i < 7; i++) {
      DateTime currentDate = startOfWeek.add(Duration(days: i));
      String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
      datesInWeek.add(formattedDate);
    }

    // Display the dates
    for (String date in datesInWeek) {
      print(date);
    }

    return datesInWeek;
  }

  String formattedDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  showAlertDialog(BuildContext context, String message) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        // Navigator.of(context).push(
        //   MaterialPageRoute(builder: (context) => Dashboard(uid: this.uid)),
        //    // Prevents going back to the intro page
        // );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class Subscription_Active {
  final dynamic start_date;
  final String uid;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final double total_price ;
  Subscription_Active({required this.total_price,required this.start_date, required this.uid});

  Future<bool> insertData() async {
    try {
//       final prefs = await SharedPreferences.getInstance();
//       Map<String, dynamic> products = {};
//       final List<String>? product = prefs.getStringList('product');
//       print('final products ready to store');
//
//       print('final products : ${products}');
//
// FirebaseFirestore.instance
//           .collection('agaram')
//           .doc('user_delivery')
//           .collection('users')
//           .doc(this.uid)
//           .collection("booking")
//           .doc('subscriptions_details')
//           .update({'issued':true,
//             'subscriptions_details':products as List});

int count=0;
for(var item in start_date)
  {
    count++;
  }
      FirebaseFirestore.instance
          .collection('agaram')
          .doc('user_delivery')
          .collection('users')
          .doc(this.uid)
          .collection("booking")
          .doc('wallets')
          .update({'subscription': this.start_date,
           'total_sub_price':total_price,
            'expire_date':count});

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}

class Subscription_Active_fordates {
  final dynamic active_date;
  final String uid;
  final double total_price;
  FirebaseAuth _auth = FirebaseAuth.instance;

  Subscription_Active_fordates({required this.total_price,required this.active_date, required this.uid});

  Future<bool> insertData() async {
    try {

      // final prefs = await SharedPreferences.getInstance();
      //   Set<String> keys =  prefs.getKeys();
      //
      //   print(keys.);
      // FirebaseFirestore.instance
      //     .collection('agaram')
      //     .doc('user_delivery')
      //     .collection('users')
      //     .doc(this.uid)
      //     .collection("booking")
      //     .doc('subscriptions_details')
      //     .update({'issued':true,
      //   'subscriptions_details':products as List});
      //


      FirebaseFirestore.instance
          .collection('agaram')
          .doc('user_delivery')
          .collection('users')
          .doc(this.uid)
          .collection("booking")
          .doc('wallets')
          .update({
        'subscription': active_date,
        'total_sub_price':total_price
    });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
