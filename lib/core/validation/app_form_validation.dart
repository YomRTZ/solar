import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFormValidation {
  static const Color errorColor = Color(0xFFBA1A1A);

  static String? requiredText(String? value, {required String fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? requiredSelection<T>(T? value, {required String fieldName}) {
    if (value == null || value.toString().trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? phoneNumber(String? value) {
    final number = (value ?? '').replaceAll(' ', '').trim();
    if (number.isEmpty) return 'Enter your mobile number';
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(number)) {
      return 'Enter a valid 10-digit mobile number';
    }
    return null;
  }

  static TextStyle get errorStyle => GoogleFonts.roboto(
    fontSize: 12,
    height: 1.2,
    color: errorColor,
  );
}

class AppFormErrorText extends StatelessWidget {
  final String message;

  const AppFormErrorText(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(message, style: AppFormValidation.errorStyle),
    );
  }
}
