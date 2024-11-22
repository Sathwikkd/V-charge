import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SuccessPage extends StatelessWidget {
  final String message;
  final bool state;
  const SuccessPage({super.key, required this.message, required this.state});

  @override
  Widget build(BuildContext context) {
    // Schedule navigation after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/devicelist', // Replace with your desired named route
        (Route<dynamic> route) => false, // Remove all routes from stack
      );
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Icon(
              state ? Icons.done : Icons.error,
              size: 60,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Center(
            child: Text(
              message,
              style: GoogleFonts.roboto(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

