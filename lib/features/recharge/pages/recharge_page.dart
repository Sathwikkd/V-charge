import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RechargePage extends StatefulWidget {
  const RechargePage({super.key});

  @override
  State<RechargePage> createState() => _RechargePageState();
}

class _RechargePageState extends State<RechargePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Recharge Page",
          style: GoogleFonts.nunito(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 30,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          

          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20 , right: 20,),
            child: TextField(
              cursorColor: Colors.black,
              decoration: InputDecoration(
                labelText: "A mount",
                labelStyle: GoogleFonts.roboto(color: Colors.black),
                border: _inputBorder(),
                enabledBorder: _inputBorder(),
                disabledBorder: _inputBorder(),
                errorBorder: _inputBorder(),
                focusedBorder: _inputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _inputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.black, width: 2),
    );
  }
}
