import 'package:flutter/material.dart';

class AppWidget {
  static TextStyle healinetextstyle(double size) {
    return TextStyle(
      color: Colors.black,
      fontSize: size,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle blacktextstyle(double size) {
    return TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.bold,
      fontSize: size,
      color: Colors.black87,
    );
  }

  static TextStyle normaltextstyle(double size) {
    return TextStyle(
        color: Colors.black, fontSize: size, fontWeight: FontWeight.w500);
  }

  static TextStyle whitetextstyle(double size) {
    return TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
      fontSize: size,
      color: Colors.white,
    );
  }

  static TextStyle greentextstyle(double size) {
    return TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.bold,
      fontSize: size,
      color: Color(0xFF2E7D32),
    );
  }

  static TextStyle lighttextstyle(double size) {
    return TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
      fontSize: size,
      color: Colors.black54,
    );
  }

  static TextStyle signupTextStyle(double size,
      {FontWeight weight = FontWeight.w600,
      Color color = const Color(0xFF4A4A4A)}) {
    return TextStyle(
      fontFamily: 'Lato',
      fontWeight: weight,
      fontSize: size,
      color: color,
    );
  }
}