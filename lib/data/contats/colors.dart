import 'package:flutter/material.dart';

final kwhite = Colors.white;
final kblack = Colors.black;
final kblue = Color(0xFF7E57C2);
AppBarTheme customAppBarTheme() {
  return const AppBarTheme(
    color: Color(0xFF6A00D7), // Purple app bar
    iconTheme: IconThemeData(color: Colors.white), // Icon theme
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
    ),
  );
}

SizedBox kheight40 = SizedBox(
  height: 40,
);
SizedBox kheight10 = SizedBox(
  height: 10,
);
// A sample base64 string of an image (replace this with your actual base64 string)
const String custombagroundimage = 'assets/images/WhatsApp Image 2024-10-17 at 2.25.11 PM.jpeg';
Image bagroundimage = Image.asset(custombagroundimage);
const String lottielogingif  = 'assets/images/Animation - 1729158303254.json';
const String lottiereferal='assets/images/Animation - 1729244860313.json';