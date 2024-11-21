import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Snackbar {
  static void showSnackbar({required String message , required IconData leadingIcon , required BuildContext context}) {
    var snackBar = SnackBar(
      content: Row(
        children: [
          const SizedBox(width: 5,),
          Icon(leadingIcon , color: Colors.black),
          const SizedBox(width: 10,),
          Text(message , style: GoogleFonts.nunito(color: Colors.black , fontWeight: FontWeight.w600)),
        ],
      ),
      backgroundColor: Colors.white,
      behavior: SnackBarBehavior.floating,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}