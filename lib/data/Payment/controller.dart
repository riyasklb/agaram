

import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';







import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {


  var isLoading = false.obs; // Observable loading state

  void showToast(
    BuildContext context, {
    required String text,
    IconData icon = Icons.info,
  }) {
    try {
      DelightToastBar(
        autoDismiss: true,
        position: DelightSnackbarPosition.top,
        builder: (context) {
          return ToastCard(
            leading: Icon(
              icon,
              size: 28,
            ),
            title: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          );
        },
      ).show(context); // Now context is passed here
    } catch (e) {
      print(e);
    }
  }





}
