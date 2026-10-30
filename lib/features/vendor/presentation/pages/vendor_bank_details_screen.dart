import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:flutter_app/core/widgets/widgets.dart';

class VendorBankDetailsScreen extends StatefulWidget {
  const VendorBankDetailsScreen({super.key});

  @override
  State<VendorBankDetailsScreen> createState() =>
      _VendorBankDetailsScreenState();
}

class _VendorBankDetailsScreenState extends State<VendorBankDetailsScreen> {
  final TextEditingController accountHolderNameController =
      TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController ifscCodeController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
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

  void _handleUpdate() {
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

    context.push(AppRoutes.vendorUploadDocuments);
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
            // ── Header ──────────────────────────────────────
            const AppHeader(title: 'Bank Details'),

            // ── Form content ─────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(19, 23, 14, 25),
                child: Column(
                  children: [
                    AppTextField(
                      label: 'Account Holder Name',
                      hint: 'Solar Trade',
                      controller: accountHolderNameController,
                    ),
                    AppTextField(
                      label: 'Account Number',
                      hint: '123456789',
                      controller: accountNumberController,
                      keyboardType: TextInputType.number,
                    ),
                    AppTextField(
                      label: 'Ifsc Code',
                      hint: 'Hdfc1002',
                      controller: ifscCodeController,
                    ),
                    AppTextField(
                      label: 'Bank Name',
                      hint: 'Hdfc Bank',
                      controller: bankNameController,
                    ),
                    const SizedBox(height: 18),
                    AppContinueButton(
                      text: 'Update',
                      onPressed: _handleUpdate,
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
