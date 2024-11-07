import 'package:flutter/material.dart';

Widget backButton(BuildContext context) {
  return IconButton(
      onPressed: () {
        Navigator.of(context).pop(true);
      },
      icon: Icon(
        Icons.arrow_back,
        color: Colors.black,
      ));
}