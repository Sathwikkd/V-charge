import 'package:flutter/material.dart';
import 'package:v_charge/views/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.black), // Updated from bodyText2 to bodyMedium
        ),
        appBarTheme: AppBarTheme(color: Colors.black),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black, // Button background color (updated from primary)
            foregroundColor: Colors.white, // Button text color (updated from onPrimary)
          ),
        ),
      ),
      home: HomePage(),
    );
  }
}
