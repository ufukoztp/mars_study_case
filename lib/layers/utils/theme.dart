import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
      primarySwatch: Colors.grey,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        shape: Border(
            bottom: BorderSide(
          color: Colors.black54,
          width: 1,
        )),
      ));
}
