import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../app/routing/app_routes.dart';
import '../../core/widgets/widgets.dart';

class BankDetailsScreen extends StatefulWidget {
  const BankDetailsScreen({super.key});

  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  final TextEditingController accountHolderNameController =
      TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController ifscCodeController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill with sample data (remove in production)
    accountHolderNameController.text = 'Solar Trade';
    accountNumberController.text = '123456789';
    ifscCodeController.text = 'Hdfc1002';
    bankNameController.text = 'Hdfc Bank';
  }

  @override
  void dispose() {
    accountHolderNameController.dispose();
    accountNumberController.dispose();
    ifscCodeController.dispose();
    bankNameController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    if (accountHolderNameController.text.isEmpty ||
        accountNumberController.text.isEmpty ||
        ifscCodeController.text.isEmpty ||
        bankNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.push(AppRoutes.uploadDocuments);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // Header
            const AppHeader(title: 'Bank Details'),

            // Form Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    AppTextField(
                      label: 'Account Holder Name',
                      hint: 'Solar Trade',
                      controller: accountHolderNameController,
                    ),
                    const SizedBox(height: 24),
                    AppTextField(
                      label: 'Account Number',
                      hint: '123456789',
                      controller: accountNumberController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 24),
                    AppTextField(
                      label: 'Ifsc Code',
                      hint: 'Hdfc1002',
                      controller: ifscCodeController,
                    ),
                    const SizedBox(height: 24),
                    AppTextField(
                      label: 'Bank Name',
                      hint: 'Hdfc Bank',
                      controller: bankNameController,
                    ),
                    const SizedBox(height: 32),
                    AppContinueButton(
                      text: 'Continue',
                      onPressed: _handleContinue,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
