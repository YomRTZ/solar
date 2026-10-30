import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:flutter_app/core/widgets/widgets.dart';

class CompanyDetailsScreen extends StatefulWidget {
  const CompanyDetailsScreen({super.key});

  @override
  State<CompanyDetailsScreen> createState() => _CompanyDetailsScreenState();
}

class _CompanyDetailsScreenState extends State<CompanyDetailsScreen> {
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController dispatchLocationController =
      TextEditingController();
  final TextEditingController gstNumberController = TextEditingController();
  final TextEditingController panNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill with sample data (remove in production)
    companyNameController.text = 'Solar Trade';
    emailController.text = 'Solar@gmail.com';
    addressController.text = '12-223 Salest, New Delhi';
    dispatchLocationController.text = '12-223 Salest, New Delhi';
    gstNumberController.text = '08TGC45879';
    panNumberController.text = '123456789';
  }

  @override
  void dispose() {
    companyNameController.dispose();
    emailController.dispose();
    addressController.dispose();
    dispatchLocationController.dispose();
    gstNumberController.dispose();
    panNumberController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    // Validate fields
    if (companyNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        addressController.text.isEmpty ||
        dispatchLocationController.text.isEmpty ||
        gstNumberController.text.isEmpty ||
        panNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Navigate to Bank Details screen
    context.push(AppRoutes.bankDetails);
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
        extendBodyBehindAppBar: true,
        body: Column(
          children: [
            // Header — reusable widget, arrow top / title bottom
            const AppHeader(title: 'Company Details'),

            // Form Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(19, 23, 14, 25),
                child: Column(
                  children: [
                    AppTextField(
                      label: 'Company Name',
                      hint: 'Solar Trade',
                      controller: companyNameController,
                    ),
                    AppTextField(
                      label: 'Email Address',
                      hint: 'Solar@gmail.com',
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    AppTextField(
                      label: 'Address',
                      hint: '12-223 Salest, New Delhi',
                      controller: addressController,
                    ),
                    AppTextField(
                      label: 'Dispatch Location',
                      hint: '12-223 Salest, New Delhi',
                      controller: dispatchLocationController,
                    ),
                    AppTextField(
                      label: 'Gst Number',
                      hint: '08TGC45879',
                      controller: gstNumberController,
                    ),
                    AppTextField(
                      label: 'Pan Number',
                      hint: '123456789',
                      controller: panNumberController,
                    ),
                    const SizedBox(height: 18),

                    // Continue Button
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
