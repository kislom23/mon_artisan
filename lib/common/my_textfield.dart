// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final icon;
  final String hintText;
  final bool obscureText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required Null Function(dynamic value) onChanged,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            prefixIcon: icon,
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors
                      .white), // Bordure quand le champ n'est pas en focus
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors
                      .orange.shade300), // Bordure quand le champ est en focus
            ),
            fillColor: Colors.grey.shade200,
            filled: true,
            hintText: hintText,
            hintStyle:
                GoogleFonts.poppins(fontSize: 15, color: Colors.grey[500])),
      ),
    );
  }
}
