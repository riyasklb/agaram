import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import 'Loginpage.dart';
import 'SubscriptionCard.dart';
import 'calendar.dart';
import 'main.dart';



class FirebaseListPage extends StatelessWidget {
  final String uid;

  FirebaseListPage({required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('agaram')
            .doc('user_delivery')
            .collection('users')
            .doc(uid)
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
              child: Text('No data available'),
            );
          } else {
            DocumentSnapshot document = snapshot.data!;
            String name = document['username'];
            String email = document['email'];
            int phone = document['mobile'];
            String address = document['address'];


            return ProfilePage(
              uid: uid,
              name: name,
              address: address,
              phone: phone,
              email: email,

            );
          }
        },
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  final String uid;
  final String name;
  final String address;
  final int phone;
  final String email;





  ProfilePage({
    required this.uid,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
  });

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Padding(
  //       padding: EdgeInsets.all(20.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           CircleAvatar(
  //             radius: 50.0,
  //             backgroundImage: AssetImage('assets/icons/person.jpg'),
  //           ),
  //           SizedBox(height: 20.0),
  //           Text(
  //             name,
  //             style: TextStyle(
  //               fontSize: 24.0,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //           SizedBox(height: 10.0),
  //           Text(
  //             address,
  //             style: TextStyle(
  //               fontSize: 18.0,
  //               color: Colors.grey[700],
  //             ),
  //           ),
  //           SizedBox(height: 20.0),
  //           Divider(
  //             height: 20.0,
  //             thickness: 2.0,
  //           ),
  //           ListTile(
  //             leading: Icon(Icons.phone),
  //             title: Text("${phone}"),
  //           ),
  //           ListTile(
  //             leading: Icon(Icons.email),
  //             title: Text(email),
  //           ),
  //
  //           SizedBox(height: 20.0),
  //
  //           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //             ElevatedButton.icon(
  //               icon: Icon(Icons.edit),
  //               onPressed: () {
  //                 // Add action for edit profile button
  //               },
  //               label: Text('Edit Profile'),
  //               style: ButtonStyle(
  //                 foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
  //                 backgroundColor: MaterialStateProperty.all<Color>(Colors.lightGreen),
  //                 shape: MaterialStateProperty.all<RoundedRectangleBorder>(
  //                   RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(24.0),
  //                   ),
  //                 ),
  //               ),
  //             ), ElevatedButton.icon(
  //               icon: Icon(Icons.logout),
  //               onPressed: () {
  //                 removeSessionAndNavigate(context);
  //               },
  //               label: Text('Logout'),
  //                 style: ButtonStyle(
  //                   foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
  //                   backgroundColor: MaterialStateProperty.all<Color>(Colors.lightGreen),
  //                   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
  //                     RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(24.0),
  //                     ),
  //                   ),
  //                 ),
  //             ),
  //           ],)
  //
  //         ],
  //       ),
  //     ),
  //   );
  // }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(100.0),
      //   child: AppBar(
      //     backgroundColor: Colors.lightGreen,
      //     automaticallyImplyLeading: false,
      //     elevation: 0,
      //     flexibleSpace: Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: Row(
      //         children: <Widget>[
      //           CircleAvatar(
      //
      //                 backgroundImage: AssetImage('assets/icons/person_icon.png'),
      //             radius: 30,
      //             backgroundColor: Colors.grey.shade800,
      //           ),
      //           SizedBox(width: 10),
      //           Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: <Widget>[
      //               Text(
      //                 this.name,
      //                 style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white, fontSize: 18),
      //               ),
      //               Text(
      //                 this.address,
      //                 style: TextStyle(color: Colors.white70,fontSize: 15,fontWeight: FontWeight.bold ),
      //               ),
      //
      //             ],
      //           ),
      //           Spacer(),
      //           // Container(
      //           //   child: Column(
      //           //     crossAxisAlignment: CrossAxisAlignment.start,
      //           //     mainAxisAlignment: MainAxisAlignment.center,
      //           //     children: <Widget>[
      //           //       Row(
      //           //         children: [
      //           //           Icon(
      //           //             Icons.account_balance_wallet,
      //           //             color: Colors.white,
      //           //           ),
      //           //           Text(
      //           //             'Wallet',
      //           //             style: TextStyle(
      //           //                 color: Colors.white,
      //           //                 fontWeight: FontWeight.normal),
      //           //           ),
      //           //         ],
      //           //       ),
      //           //       SizedBox(height: 3),
      //           //       Text(
      //           //         'Rs.50',
      //           //         style: TextStyle(
      //           //             color: Colors.white,
      //           //             fontWeight: FontWeight.bold,
      //           //             fontSize: 20),
      //           //       ),
      //           //       SizedBox(height: 0),
      //           //       Text(
      //           //         'Available Balance',
      //           //         style: TextStyle(
      //           //             color: Colors.white, fontWeight: FontWeight.normal),
      //           //       ),
      //           //     ],
      //           //   ),
      //           // ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),

      body: ListView(
        children: <Widget>[
          MenuGroup([
            ListTile(
              leading: Icon(Icons.location_on, color: Colors.indigoAccent[400]),
              title: Text('My Address'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.history, color: Colors.indigoAccent[400]),
              title: Text('Order History'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            ListTile(
              leading:
              Icon(Icons.shopping_bag, color: Colors.indigoAccent[400]),
              title: Text('Delivery Preferences'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DeliveryPreference(),
                  ),
                );
              },
            ),
          ]),
          MenuGroup([
            ListTile(
              leading: Icon(Icons.beach_access, color: Colors.greenAccent[700]),
              title: Text('Vacations Mode'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Vacation(uid: this.uid),
                  ),
                );
              },
            ),
            ListTile(
              leading:
              Icon(Icons.card_giftcard, color: Colors.greenAccent[700]),
              title: Text('Refer & Earn'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.language, color: Colors.greenAccent[700]),
              title: Text('Language'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.star, color: Colors.greenAccent[700]),
              title: Text('Rate us'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
          ]),
          MenuGroup([
            ListTile(
              leading: Icon(Icons.help, color: Colors.greenAccent[700]),
              title: Text('Help & Support'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.info_outline, color: Colors.greenAccent[700]),
              title: Text('Legal and About us'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
          ]),
          MenuGroup([
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.red),
              title: Text('Logout'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {

                removeSessionAndNavigate(context);
              },
            ),
          ]),
        ],
      ),
    );
  }

  // Function to remove session and navigate to another page
  void removeSessionAndNavigate(BuildContext context) async {
    // Remove session data
    await removeSession();

    // Navigate to another page
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => MyApp()), // Replace LoginPage() with your desired page
          (Route<dynamic> route) => false, // Prevents going back to the login page
    );
  }

  // Function to remove session data
  Future<void> removeSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('auth_email');
    await prefs.remove('auth_password');
  }

}


class MenuGroup extends StatelessWidget {
  final List<Widget> items;

  MenuGroup(this.items);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: items.map((item) {
          return Column(
            children: [
              item,
              Divider(
                color: Colors.grey,
                thickness: 0.5,
                height: 0.0,
                indent: 15,
                endIndent: 15,
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}


class Vacation extends StatelessWidget {
  final String uid;

  Vacation({required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vacation Planner'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _showVacationDialog(context, uid);
          },
          child: Text('Select Vacation Dates'),
        ),
      ),
    );
  }

  void _showVacationDialog(BuildContext context, String uid) {
    List<DateTime> selectedDates = [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Vacation Dates'),
          content: SizedBox(
            width: 350,
            height: 400,
            child: MultiDayPicker(
              onSelectedDatesChanged: (dates) {
                selectedDates = dates;
              },
            ),
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
                if (selectedDates.isNotEmpty) {
                  _saveVacationDates(selectedDates, uid);
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) =>   CalendarPage(uid: this.uid)),
                    // Prevents going back to the intro page
                  );
                  const snackBar = SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 8),
                        Text('Vacation Days Added!'),
                      ],
                    ),
                    backgroundColor: Colors.lightGreen,
                    duration: Duration(seconds: 3),

                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please select at least one date.'),
                    ),
                  );
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _saveVacationDates(List<DateTime> dates, String uid) {
    List<dynamic> formattedDates =
    dates.map((date) => DateFormat('yyyy-MM-dd').format(date)).toList();

     FirebaseFirestore.instance
          .collection('agaram')
          .doc('user_delivery')
          .collection('users')
          .doc(this.uid)
          .collection("booking")
          .doc('wallets')
          .update({
        'vacation': formattedDates
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Vacation dates saved successfully.'),
      //   ),
      // );
    }).catchError((error) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Failed to save vacation dates: $error'),
      //   ),
      // );
    });
  }
}


class Subscription_Active {
  final List<String> start_date;
  final String uid;
  FirebaseAuth _auth = FirebaseAuth.instance;

  Subscription_Active({required this.start_date, required this.uid});

  Future<bool> insertData() async {
    try {
      await FirebaseFirestore.instance
          .collection('agaram')
          .doc('user_delivery')
          .collection('users')
          .doc(this.uid)
          .collection("booking")
          .doc('wallets')
          .update({
        'subscription': start_date
      });
      return true;

    } catch (e) {
      print(e);
      return false;
    }
  }
}

//
// class Subscription_Active {
//   final List<String> start_date;
//   final String uid;
//   FirebaseAuth _auth = FirebaseAuth.instance;
//
//   Subscription_Active({required this.start_date, required this.uid});
//
//   Future<bool> insertData() async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('agaram')
//           .doc('user_delivery')
//           .collection('users')
//           .doc(this.uid)
//           .collection("booking")
//           .doc('wallets')
//           .update({
//         'vacation': start_date
//       });
//       return true;
//     } catch (e) {
//       print(e);
//       return false;
//     }
//   }
// }



//DeliveryPrefrence
class DeliveryPreference extends StatefulWidget {
  const DeliveryPreference({Key? key}) : super(key: key);

  @override
  State<DeliveryPreference> createState() => _DeliveryInstructionsState();
}

class _DeliveryInstructionsState extends State<DeliveryPreference> {
  String selectedInstruction = 'Ring Doorbell';
  String additionalInstructions = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[600],
        foregroundColor: Colors.white,
        title: const Text('Delivery Preference'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0),
            child: Text(
              'Delivery Instructions',
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  buildInstructionItem('Ring Doorbell'),
                  buildInstructionItem('Leave at Door'),
                  buildInstructionItem('In-Hand Delivery'),
                  buildInstructionItem('Keep in Insulated Bag'),
                  buildInstructionItem('No Preference'),
                  const SizedBox(height: 16.0),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                          color: const Color.fromARGB(255, 102, 95, 95)),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Additional Instructions (optional)',
                        contentPadding: const EdgeInsets.all(12.0),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text('Disclaimer - This is help us to deliver faster'),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 1.5,
          height: 50,
          child: FloatingActionButton.extended(
            onPressed: () {},
            label: Text(
              'Submit',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.deepPurple[600],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

//custom icon
  Widget buildInstructionItem(String text) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
            title: Text(text, style: const TextStyle(fontSize: 16.0)),
            leading: selectedInstruction == text
                ? const Icon(Icons.check_circle, color: Colors.deepPurple)
                : const Icon(Icons.circle, color: Colors.grey),
            onTap: () => setState(() => selectedInstruction = text),
          ),
        ),
        const Divider(
          color: Colors.grey,
          height: 0,
          thickness: 0.5,
          indent: 16,
          endIndent: 16,
        ),
      ],
    );
  }
}
