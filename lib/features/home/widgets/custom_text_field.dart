import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  const CustomTextField({super.key, required this.controller , required this.enabled});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: "Machine ID",
        border: _borderStyle(),
        errorBorder: _borderStyle(),
        focusedBorder: _borderStyle(),
        disabledBorder: _borderStyle(),
        enabledBorder: _borderStyle(),
        focusedErrorBorder: _borderStyle(),
        enabled: enabled,
      ),
    );
  }

  _borderStyle() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide:const BorderSide(
        color: Colors.black,
      ),
    );
  }
}
