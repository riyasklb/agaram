import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class PDFGenerator {
  final String uid;

  PDFGenerator(this.uid);

  Future<Map<String, dynamic>?> fetchProfileDetails() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('agaram')
        .doc('user_delivery')
        .collection('users')
        .doc(uid)
        .get();

    return doc.exists ? doc.data() as Map<String, dynamic>? : null;
  }

  Future<Map<String, dynamic>?> fetchSubscriptionDetails() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('agaram')
        .doc('user_delivery')
        .collection('users')
        .doc(uid)
        .get();

    return doc.exists ? doc['subscription'] as Map<String, dynamic>? : null;
  }

  Future<void> generatePDF(BuildContext context) async {
    final profile = await fetchProfileDetails();
    final subscription = await fetchSubscriptionDetails();

    if (profile == null || subscription == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching data for PDF generation.')));
      return;
    }

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Subscription Invoice', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.Divider(),

              // Profile Details Section
              pw.Text('Profile Details', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Text('Name: ${profile['username']}', style: pw.TextStyle(fontSize: 16)),
              pw.Text('Email: ${profile['email']}', style: pw.TextStyle(fontSize: 16)),
              pw.Text('Phone: ${profile['mobile']}', style: pw.TextStyle(fontSize: 16)),
              pw.Text('Address: ${profile['address']}', style: pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 16),

              // Subscription Details Section
              pw.Text('Subscription Details', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Text('Total Price: ₹${subscription['total_price']}', style: pw.TextStyle(fontSize: 16)),
              pw.Text('Start Date: ${subscription['start_date'].toDate().toString().split(' ')[0]}', style: pw.TextStyle(fontSize: 16)),
              pw.Text('End Date: ${subscription['end_date'].toDate().toString().split(' ')[0]}', style: pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 16),

              // Products List
              pw.Text('Products:', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.ListView.builder(
                itemCount: subscription['products'].length,
                itemBuilder: (context, index) {
                  final product = subscription['products'][index];
                  return pw.Container(
                    margin: pw.EdgeInsets.symmetric(vertical: 8),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Product Name: ${product['name']}', style: pw.TextStyle(fontSize: 16)),
                        pw.Text('Quantity: ${product['quantity']}', style: pw.TextStyle(fontSize: 14)),
                        pw.Text('Price: ₹${product['price']}', style: pw.TextStyle(fontSize: 14)),
                        pw.Text('Start Date: ${product['start_date'].toDate().toString().split(' ')[0]}', style: pw.TextStyle(fontSize: 14)),
                        pw.Text('End Date: ${product['end_date'].toDate().toString().split(' ')[0]}', style: pw.TextStyle(fontSize: 14)),
                      ],
                    ),
                  );
                },
              ),
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
}
