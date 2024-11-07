import 'dart:io';
import 'package:agaram_dairy/data/contats/colors.dart';
import 'package:agaram_dairy/data/details/hold_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionDetailsScreen extends StatefulWidget {
  final String uid;

  const SubscriptionDetailsScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _SubscriptionDetailsScreenState createState() => _SubscriptionDetailsScreenState();
}

class _SubscriptionDetailsScreenState extends State<SubscriptionDetailsScreen> with SingleTickerProviderStateMixin {
  Map<String, dynamic>? subscription;
  Map<String, dynamic>? profile;
  String? holdDate; // Variable to store the hold date
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchData();
  }

  Future<void> fetchData() async {
    subscription = await fetchSubscriptionDetails();
    profile = await fetchUserProfile();
    holdDate = await fetchHoldDate(); // Fetch the hold date
    setState(() {});
  }

  Future<Map<String, dynamic>?> fetchSubscriptionDetails() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('agaram')
          .doc('user_delivery')
          .collection('users')
          .doc(widget.uid)
          .get();

      return doc.exists ? doc['subscription'] as Map<String, dynamic>? : null;
    } catch (e) {
      print("Error fetching subscription details: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchUserProfile() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('agaram')
          .doc('user_delivery')
          .collection('users')
          .doc(widget.uid)
          .get();

      return doc.exists ? doc.data() as Map<String, dynamic>? : null;
    } catch (e) {
      print("Error fetching profile details: $e");
      return null;
    }
  }

  Future<String?> fetchHoldDate() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('agaram')
          .doc('user_delivery')
          .collection('users')
          .doc(widget.uid)
          .get();

      // Fetch the hold date from the subscription document (if exists)
      if (doc.exists && doc['subscription'] != null && doc['subscription']['hold_date'] != null) {
        return (doc['subscription']['hold_date'] as Timestamp).toDate().toString().split(' ')[0]; // Format the date
      }
      return null;
    } catch (e) {
      print("Error fetching hold date: $e");
      return null;
    }
  }

  Future<void> generateAndSharePDF() async {
    if (subscription == null || profile == null) return;

    final pdf = pw.Document();
    // PDF generation logic (remains same)
    final directory = await getTemporaryDirectory();
    final filePath = "${directory.path}/subscription_invoice.pdf";
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles([XFile(filePath)], text: 'Here is your subscription invoice');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: InkWell(
            onTap: () {
              Get.to(SubscriptionSettingsScreen(uid: widget.uid));
            },
            child: Icon(Icons.settings, color: kwhite)),
        backgroundColor: Colors.green,
        title: Text(
          'Subscription Details',
          style: GoogleFonts.lato(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: subscription == null || profile == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Tab Bar
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.green,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.green,
                  tabs: const [
                    Tab(icon: Icon(Icons.person), text: 'User Profile'),
                    Tab(icon: Icon(Icons.subscriptions), text: 'Subscription'),
                    Tab(icon: Icon(Icons.list), text: 'Products'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      buildUserProfileTab(),
                      buildSubscriptionDetailsTab(),
                      buildProductsTab(),
                    ],
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: generateAndSharePDF,
        icon: Icon(Icons.share, color: kwhite),
        label: Text("Share Invoice", style: TextStyle(color: kwhite)),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget buildUserProfileTab() {
    return Padding(
      padding: EdgeInsets.all(16.0.w),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'User Profile',
                style: GoogleFonts.poppins(fontSize: 22.sp, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              Divider(),
              Text('Name: ${profile!['username']}', style: TextStyle(fontSize: 18.sp)),
              Text('Email: ${profile!['email']}', style: TextStyle(fontSize: 18.sp)),
              Text('Phone: ${profile!['mobile']}', style: TextStyle(fontSize: 18.sp)),
              Text('Address: ${profile!['address']}', style: TextStyle(fontSize: 18.sp)),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSubscriptionDetailsTab() {
    return Padding(
      padding: EdgeInsets.all(16.0.w),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Subscription Details',
                style: GoogleFonts.poppins(fontSize: 22.sp, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              Divider(),
              Text('Total Price: ₹${subscription!['total_price']}', style: TextStyle(fontSize: 18.sp)),
              Text('Start Date: ${subscription!['start_date'].toDate().toString().split(' ')[0]}', style: TextStyle(fontSize: 18.sp)),
              Text('End Date: ${subscription!['end_date'].toDate().toString().split(' ')[0]}', style: TextStyle(fontSize: 18.sp)),
              if (holdDate != null) ...[
                Divider(),
                Text('Hold Date: $holdDate', style: TextStyle(fontSize: 18.sp, color: Colors.orange)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProductsTab() {
    return Padding(
      padding: EdgeInsets.all(16.0.w),
      child: ListView.builder(
        itemCount: subscription!['products'].length,
        itemBuilder: (context, index) {
          var product = subscription!['products'][index];
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            margin: EdgeInsets.only(bottom: 12.h),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: GoogleFonts.poppins(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  Divider(),
                  Text('Quantity: ${product['quantity']}', style: TextStyle(fontSize: 16.sp)),
                  Text('Price: ₹${product['price']}', style: TextStyle(fontSize: 16.sp)),
                  Text('Start Date: ${product['start_date'].toDate().toString().split(' ')[0]}', style: TextStyle(fontSize: 16.sp)),
                  Text('End Date: ${product['end_date'].toDate().toString().split(' ')[0]}', style: TextStyle(fontSize: 16.sp)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
