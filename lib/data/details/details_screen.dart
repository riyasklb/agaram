import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionDetailsScreen extends StatelessWidget {
  final String uid;

  const SubscriptionDetailsScreen({Key? key, required this.uid}) : super(key: key);

  Future<Map<String, dynamic>?> fetchSubscriptionDetails() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('agaram')
          .doc('user_delivery')
          .collection('users')
          .doc(uid)
          .get();

      return doc.exists ? doc['subscription'] as Map<String, dynamic>? : null;
    } catch (e) {
      print("Error fetching subscription details: $e");
      return null;
    }
  }

  Future<void> generateAndSharePDF(Map<String, dynamic> subscription, Map<String, dynamic> profile) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Subscription Invoice', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('User Profile', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.Text('Name: ${profile['username']}'),
              pw.Text('Email: ${profile['email']}'),
              pw.Text('Phone: ${profile['mobile']}'),
              pw.Text('Address: ${profile['address']}'),
              pw.SizedBox(height: 20),
              pw.Text('Subscription Details', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.Text('Total Price: ${subscription['total_price']}'),
              pw.Text('Start Date: ${subscription['start_date'].toDate().toString().split(' ')[0]}'),
              pw.Text('End Date: ${subscription['end_date'].toDate().toString().split(' ')[0]}'),
              pw.SizedBox(height: 20),
              pw.Text('Products:', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              ...subscription['products'].map<pw.Widget>((product) {
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Product Name: ${product['name']}'),
                    pw.Text('Quantity: ${product['quantity']}'),
                    pw.Text('Price: ${product['price']}'),
                    pw.Text('Start Date: ${product['start_date'].toDate().toString().split(' ')[0]}'),
                    pw.Text('End Date: ${product['end_date'].toDate().toString().split(' ')[0]}'),
                    pw.SizedBox(height: 10),
                  ],
                );
              }).toList(),
            ],
          );
        },
      ),
    );

    final directory = await getTemporaryDirectory();
    final filePath = "${directory.path}/subscription_invoice.pdf";
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles([XFile(filePath)], text: 'Here is your subscription invoice');
  }

  Future<Map<String, dynamic>?> fetchUserProfile() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('agaram')
          .doc('user_delivery')
          .collection('users')
          .doc(uid)
          .get();

      return doc.exists ? doc.data() as Map<String, dynamic>? : null;
    } catch (e) {
      print("Error fetching profile details: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
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
      body: FutureBuilder<Map<String, dynamic>?>(
        future: fetchSubscriptionDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return Center(child: Text('No subscription details found.'));
          }

          final subscription = snapshot.data!;

          return Padding(
            padding: EdgeInsets.all(16.0.w),
            child: ListView(
              children: [
                // User Profile Section
                FutureBuilder<Map<String, dynamic>?>(
                  future: fetchUserProfile(),
                  builder: (context, profileSnapshot) {
                    if (profileSnapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (profileSnapshot.hasError || profileSnapshot.data == null) {
                      return Text('No profile details found.');
                    }

                    final profile = profileSnapshot.data!;
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8.h),
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'User Profile',
                              style: GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8.h),
                            Text('Name: ${profile['username']}'),
                            Text('Email: ${profile['email']}'),
                            Text('Phone: ${profile['mobile']}'),
                            Text('Address: ${profile['address']}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 16.h),

                // Subscription Details Section
                Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8.h),
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Subscription Details',
                          style: GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8.h),
                        Text('Total Price: ₹${subscription['total_price']}'),
                        Text('Start Date: ${subscription['start_date'].toDate().toString().split(' ')[0]}'),
                        Text('End Date: ${subscription['end_date'].toDate().toString().split(' ')[0]}'),
                      ],
                    ),
                  ),
                ),

                // Products Section
                Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8.h),
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Products',
                          style: GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8.h),
                        Column(
                          children: subscription['products'].map<Widget>((product) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 10.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Product Name: ${product['name']}'),
                                  Text('Quantity: ${product['quantity']}'),
                                  Text('Price: ${product['price']}'),
                                  Text('Start Date: ${product['start_date'].toDate().toString().split(' ')[0]}'),
                                  Text('End Date: ${product['end_date'].toDate().toString().split(' ')[0]}'),
                                  Divider(),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),

                // Share Invoice Button
                SizedBox(height: 20.h),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      final profile = await fetchUserProfile();
                      if (profile != null) {
                        await generateAndSharePDF(subscription, profile);
                      } else {
                        print("Failed to fetch user profile details.");
                      }
                    },
                    child: Text("Share Invoice"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
