import 'dart:io';

import 'package:agaram_dairy/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel, EventList;
import 'ProductListScreen.dart';

class CalendarPage extends StatefulWidget {
  final String uid;
  const CalendarPage({Key? key, required this.uid}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late Map<DateTime, List<Event>> markedsub;

  @override
  void initState() {
    super.initState();
    markedsub = {};

    fetchupSubscription();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.beach_access),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Vacation(uid:widget.uid),
                ),
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: constraints.maxHeight > 600 ? 20 : 15,
                // Adjust the ratio based on screen height
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: ScrollableCleanCalendar(
                    markedDates: markedsub,
                    uid: widget.uid,
                  ),
                ),
              ),
              const Divider(),
              Expanded(
                flex:0,
                // Adjust the ratio based on screen height
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child:RUN_LABEL(uid: widget.uid)
                    // LabelWidget(color: Colors.red, label: 'Current Day'),
                    // LabelWidget(color: Colors.red, label: 'Rejected Delivery'),
                    // LabelWidget(color: Colors.purple, label: 'Vacation Day'),
                ),
              ),
              const Divider(),
              Expanded(
                flex: constraints.maxHeight > 600 ? 1 : 4,
                // Adjust the ratio based on screen height
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: BottomCardView(uid: widget.uid),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> fetchupSubscription() async {
    final DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('agaram')
        .doc('user_delivery')
        .collection('users')
        .doc(widget.uid) // Replace 'uid' with the actual user ID
        .collection('booking')
        .doc('wallets') // Replace 'wallets' with the actual document ID
        .get();

    if (!snapshot.exists) {
      print("No Data Found!");
      return;
    }

    final List<dynamic> subscription = snapshot['subscription'];
    final List<dynamic> vacation = snapshot['vacation'];

    // if (subscription == null && vacation ==null) {
    //
    //   print("No data available.");
    //   return;
    // }

    setState(() {
      markedsub = {

        DateTime(2024, 5, 20): [
          Event(date: DateTime(2024, 5, 20), title: 'rejected_delivery'),
        ],
        DateTime(2024, 5, 30): [
          Event(date: DateTime(2024, 5, 30), title: 'delivered'),
        ],

        for (var date in subscription)
          _convertToDateTime(date): [  // Convert string date to DateTime and add to markedsub
            Event(date: _convertToDateTime(date), title: 'subscription_date'),
          ],
        for (var date in vacation)
        _convertToDateTime(date): [  // Convert string date to DateTime and add to markedsub
          Event(date: _convertToDateTime(date), title: 'vacation_period'),
        ],
      };
      print("Successfully Stored");
    });
  }

  DateTime _convertToDateTime(String dateString) {
    // Split the date string by '-' to get year, month, and day
    List<String> parts = dateString.split('-');
    // Convert the parts to integers and create a DateTime object
    print("Converting : $parts");
    return DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
  }
}

class ScrollableCleanCalendar extends StatelessWidget {
  final Map<DateTime, List<Event>> markedDates;
  final String uid;
  ScrollableCleanCalendar({required this.markedDates, required this.uid});

  @override
  Widget build(BuildContext context) {
    EventList<Event> markedDatesMap = EventList<Event>(
      events: markedDates,
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Center(
            child: CalendarCarousel<Event>(
              // markedDatesMap: markedDatesMap,
              customDayBuilder: (
                  bool isSelectable,
                  int index,
                  bool isSelectedDay,
                  bool isToday,
                  bool isPrevMonthDay,
                  TextStyle textStyle,
                  bool isNextMonthDay,
                  bool isThisMonthDay,
                  DateTime day,
                  ) {
                if (markedDates.containsKey(day) &&
                    markedDates[day]!.any((event) => event.title == 'subscription_date')) {
                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18, // Adjust font size as needed
                          fontWeight: FontWeight.bold, // Make the text bold
                        ),
                      ),
                    ),
                  );
                } else if (isPrevMonthDay || (!isThisMonthDay && !isNextMonthDay)) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(30)), // Adjust the radius value as needed
                      border: Border.all(color: Colors.transparent), // Red border
                    ),
                    child: Center(
                      child: Text(
                        '',
                        style: TextStyle(
                          color: Colors.transparent,
                          fontSize: 18, // Adjust font size as needed
                          fontWeight: FontWeight.bold, // Make the text bold
                        ),
                      ),
                    ),
                  );
                } else if (isToday) {
                  return Container(
                    decoration: BoxDecoration(
                      color: (markedDates.containsKey(day) &&
                          markedDates[day]!.any((event) => event.title == 'subscription_date')) ? Colors.blue[100] : Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30)), // Adjust the radius value as needed
                      border: Border.all(color: Colors.red), // Red border
                    ),
                    child: Center(
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18, // Adjust font size as needed
                          fontWeight: FontWeight.bold, // Make the text bold
                        ),
                      ),
                    ),
                  );
                } else if (markedDates.containsKey(day) &&
                    markedDates[day]!.any((event) => event.title == 'rejected_delivery')) {
                  return Container(
                    width: 40, // Adjust width as needed
                    height: 40, // Adjust height as needed
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18, // Adjust font size as needed
                          fontWeight: FontWeight.bold, // Make the text bold
                        ),
                      ),
                    ),
                  );
                } else if (markedDates.containsKey(day) &&
                    markedDates[day]!.any((event) => event.title == 'vacation_period')) {
                  return Container(
                    width: 40, // Adjust width as needed
                    height: 40, // Adjust height as needed
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18, // Adjust font size as needed
                          fontWeight: FontWeight.bold, // Make the text bold
                        ),
                      ),
                    ),
                  );
                } else if (markedDates.containsKey(day) &&
                    markedDates[day]!.any((event) => event.title == 'delivered')) {
                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.greenAccent[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18, // Adjust font size as needed
                          fontWeight: FontWeight.bold, // Make the text bold
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  );
                }
              },
              onDayPressed: (DateTime date, List<Event> events) {
                print(date);
              },
            ),
          ),
        ),
      ),
    );
  }
}

class BottomCardView extends StatelessWidget {
  final String uid;

  const BottomCardView({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('agaram')
          .doc('user_delivery')
          .collection('users')
          .doc(uid)
          .collection('booking')
          .doc('products') // Replace 'your_document_id' with the actual document ID
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(
            child: Text('No Products Found!'),
          );
        } else {
          final Timestamp? orderPlaced = snapshot.data!.get('order_placed') as Timestamp?;

          if (orderPlaced == null) {
            return Center(
              child: Text('Order Date Not Found!'),
            );
          }

          final DateTime orderDate = orderPlaced.toDate();

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductListScreen(productDocument: snapshot.data!),
                ),
              );
            },
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                title: Text(
                  'Order Date: ${orderDate.toString()}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  'click to view orders',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

class LabelWidget extends StatelessWidget {
  final Color color;
  final String label;

  LabelWidget({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4), // Adjust margin as needed
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Circle representing the label color
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          SizedBox(width: 4), // Adjust spacing as needed
          // Label text
          Text(
            label,
            style: TextStyle(fontSize: 12), // Adjust font size as needed
          ),
        ],
      ),
    );
  }
}


class RUN_LABEL extends StatelessWidget {
final String uid;
  RUN_LABEL({required this.uid});

  @override
  Widget build(BuildContext context) {
    return
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [


          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              LabelWidget(color: Colors.blue, label: 'Subscription Dates'),
              // Example labels
              LabelWidget(color: Colors.green, label: 'Delivery Success'),
              LabelWidget(color: Colors.red, label: 'Rejected Delivery'),
              LabelWidget(color: Colors.purple, label: 'Vacation Day'),


            ],
      ),Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(         onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Vacation(uid:this.uid),
                  ),
                );
              },icon: Icon(Icons.beach_access_outlined),

                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                    backgroundColor: WidgetStateProperty.all<Color>(Colors.lightGreen),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                    ),
                  ),
                  label: Text("Add Vacation"))
              //
              // actions: [
              //   IconButton(
              //     icon: const Icon(Icons.beach_access),

              //   ),
              // ],
            ],
          )
        ],
      );



  }
}

