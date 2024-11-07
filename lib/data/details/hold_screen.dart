import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionSettingsScreen extends StatefulWidget {
  final String uid;

  const SubscriptionSettingsScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _SubscriptionSettingsScreenState createState() => _SubscriptionSettingsScreenState();
}

class _SubscriptionSettingsScreenState extends State<SubscriptionSettingsScreen> {
  late TimeOfDay _currentTime;
  late DateTime _holdDate;
  late DateTime _continueDate;

  @override
  void initState() {
    super.initState();
    _currentTime = TimeOfDay.now();
    _setHoldDate();
  }

  void _setHoldDate() {
    DateTime now = DateTime.now();
    if (_currentTime.hour < 22) {
      // If before 10 PM, hold date is today
      _holdDate = now;
    } else {
      // If after 10 PM, hold date is tomorrow
      _holdDate = now.add(Duration(days: 1));
    }
    _continueDate = now.add(Duration(days: 30)); // Assuming 30 days for continue date
  }

  Future<void> _holdSubscription() async {
    bool confirmed = await _showConfirmationDialog("Hold Subscription", "Are you sure you want to hold your subscription?");
    if (confirmed) {
      // Update Firestore with hold date
      await FirebaseFirestore.instance
          .collection('agaram')
          .doc('user_delivery')
          .collection('users')
          .doc(widget.uid)
          .update({
        'subscription.hold_date': _holdDate,
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Subscription held until ${_holdDate.toLocal()}")));
    }
  }

  Future<void> _continueSubscription() async {
    bool confirmed = await _showConfirmationDialog("Continue Subscription", "Are you sure you want to continue your subscription?");
    if (confirmed) {
      // Update Firestore with continue date
      await FirebaseFirestore.instance
          .collection('agaram')
          .doc('user_delivery')
          .collection('users')
          .doc(widget.uid)
          .update({
        'subscription.continue_date': _continueDate,
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Subscription will continue from ${_continueDate.toLocal()}")));
    }
  }

  Future<bool> _showConfirmationDialog(String title, String message) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text("Cancel", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text("Confirm", style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Subscription Settings',
          style: GoogleFonts.lato(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subscription Hold and Continue section
            Text(
              'Subscription Hold and Continue',
              style: GoogleFonts.poppins(fontSize: 22.sp, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            SizedBox(height: 20.h),
            Text(
              'Current Time: ${_currentTime.format(context)}',
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(height: 10.h),
            Text(
              'Hold Date: ${_holdDate.toLocal()}',
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                // Hold Subscription Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: _holdSubscription,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Hold Subscription",
                      style: TextStyle(fontSize: 18.sp, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                // Continue Subscription Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: _continueSubscription,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Continue Subscription",
                      style: TextStyle(fontSize: 18.sp, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
