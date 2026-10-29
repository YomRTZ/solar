import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../app/routing/app_routes.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/app_header.dart';
import '../../core/widgets/app_continue_button.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController contactPersonController = TextEditingController();
  final TextEditingController deliveryAddressController =
      TextEditingController();
  final TextEditingController gstNumberController = TextEditingController();
  final TextEditingController panNumberController = TextEditingController();

  @override
  void dispose() {
    businessNameController.dispose();
    contactPersonController.dispose();
    deliveryAddressController.dispose();
    gstNumberController.dispose();
    panNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.white,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          color: Colors.white,
          child: SafeArea(
            top: false,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = constraints.maxWidth;
                final screenHeight = MediaQuery.sizeOf(context).height;

                return Column(
                  children: [
                    // Reusable header widget
                    const AppHeader(title: 'Create Account', height: 133),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                        ),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.only(top: 7, bottom: 24),
                          child: Center(
                            child: SizedBox(
                              width: screenWidth < 327 ? screenWidth : 327,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      AppTextField(
                                        label: 'Business Name',
                                        hint: 'Solar Trade',
                                        controller: businessNameController,
                                      ),
                                      const SizedBox(height: 24),
                                      AppTextField(
                                        label: 'Contact Person',
                                        hint: 'Rahul Roy',
                                        controller: contactPersonController,
                                      ),
                                      const SizedBox(height: 24),
                                      AppTextField(
                                        label: 'Delivery Address',
                                        hint: '123-33 New Delhi - 112234',
                                        controller: deliveryAddressController,
                                      ),
                                      const SizedBox(height: 24),
                                      AppTextField(
                                        label: 'Gst Number',
                                        hint: '9876546879',
                                        controller: gstNumberController,
                                        keyboardType: TextInputType.number,
                                      ),
                                      const SizedBox(height: 24),
                                      AppTextField(
                                        label: 'Pan Number',
                                        hint: '12345678',
                                        controller: panNumberController,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  AppContinueButton(
                                    text: 'Continue',
                                    onPressed: () {
                                      context.push(AppRoutes.choosePlan);
                                    },
                                  ),
                                  SizedBox(height: screenHeight * 0.02),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
