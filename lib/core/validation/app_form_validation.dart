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

  /// Validates a positive monetary amount.
  /// Accepts values with or without commas (e.g. "20,000" or "20000").
  static String? positiveAmount(String? value, {String fieldName = 'Amount'}) {
    final cleaned = (value ?? '').replaceAll(',', '').trim();
    if (cleaned.isEmpty) return '$fieldName is required';
    final amount = double.tryParse(cleaned);
    if (amount == null) return 'Enter a valid $fieldName';
    if (amount <= 0) return '$fieldName must be greater than 0';
    return null;
  }

  /// Validates a non-negative monetary amount (0 is allowed).
  static String? nonNegativeAmount(
    String? value, {
    String fieldName = 'Amount',
  }) {
    final cleaned = (value ?? '').replaceAll(',', '').trim();
    if (cleaned.isEmpty) return '$fieldName is required';
    final amount = double.tryParse(cleaned);
    if (amount == null) return 'Enter a valid $fieldName';
    if (amount < 0) return '$fieldName cannot be negative';
    return null;
  }

  /// Validates a positive integer (e.g. quantity).
  static String? positiveInteger(
    String? value, {
    String fieldName = 'Value',
  }) {
    final cleaned = (value ?? '').trim();
    if (cleaned.isEmpty) return '$fieldName is required';
    final number = int.tryParse(cleaned);
    if (number == null) return 'Enter a valid whole number for $fieldName';
    if (number <= 0) return '$fieldName must be greater than 0';
    return null;
  }

  /// Validates a 6-digit Indian pincode.
  static String? pincode(String? value) {
    final cleaned = (value ?? '').trim();
    if (cleaned.isEmpty) return 'Pincode is required';
    if (!RegExp(r'^\d{6}$').hasMatch(cleaned)) {
      return 'Enter a valid 6-digit pincode';
    }
    return null;
  }

  /// Validates an Indian bank account number (9–18 digits).
  static String? accountNumber(String? value) {
    final cleaned = (value ?? '').trim();
    if (cleaned.isEmpty) return 'Account number is required';
    if (!RegExp(r'^\d{9,18}$').hasMatch(cleaned)) {
      return 'Enter a valid account number (9–18 digits)';
    }
    return null;
  }

  /// Validates an Indian IFSC code (e.g. HDFC0001234).
  static String? ifscCode(String? value) {
    final cleaned = (value ?? '').trim().toUpperCase();
    if (cleaned.isEmpty) return 'IFSC code is required';
    if (!RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$').hasMatch(cleaned)) {
      return 'Enter a valid IFSC code (e.g. HDFC0001234)';
    }
    return null;
  }

  /// Validates a 15-character Indian GSTIN.
  static String? gstNumber(String? value) {
    final cleaned = (value ?? '').trim().toUpperCase();
    if (cleaned.isEmpty) return 'GST number is required';
    if (!RegExp(
      r'^\d{2}[A-Z]{5}\d{4}[A-Z]{1}[A-Z\d]{1}[Z]{1}[A-Z\d]{1}$',
    ).hasMatch(cleaned)) {
      return 'Enter a valid 15-character GST number';
    }
    return null;
  }

  /// Validates a GST percentage value (0–100, optional % suffix allowed).
  static String? gstPercentage(String? value) {
    final cleaned = (value ?? '').replaceAll('%', '').trim();
    if (cleaned.isEmpty) return 'GST is required';
    final percent = double.tryParse(cleaned);
    if (percent == null) return 'Enter a valid GST percentage';
    if (percent < 0 || percent > 100) return 'GST must be between 0 and 100';
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
