import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/app_button.dart';
import '../plan/choose_plan_screen.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController contactPersonController = TextEditingController();
  final TextEditingController deliveryAddressController = TextEditingController();
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.splashGradient,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.02,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    SizedBox(width: screenWidth * 0.04),
                    Text(
                      'Create Account',
                      style: GoogleFonts.roboto(
                        fontSize: screenWidth * 0.065,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.08,
                        vertical: screenHeight * 0.03,
                      ),
                      child: Column(
                        children: [
                          AppTextField(
                            label: 'Business Name',
                            hint: 'Solar Trade',
                            controller: businessNameController,
                          ),
                          SizedBox(height: screenHeight * 0.025),
                          AppTextField(
                            label: 'Contact Person',
                            hint: 'Rahul Roy',
                            controller: contactPersonController,
                          ),
                          SizedBox(height: screenHeight * 0.025),
                          AppTextField(
                            label: 'Delivery Address',
                            hint: '123-33 New Delhi - 112234',
                            controller: deliveryAddressController,
                          ),
                          SizedBox(height: screenHeight * 0.025),
                          AppTextField(
                            label: 'Gst Number',
                            hint: '9876546879',
                            controller: gstNumberController,
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: screenHeight * 0.025),
                          AppTextField(
                            label: 'Pan Number',
                            hint: '12345678',
                            controller: panNumberController,
                          ),
                          SizedBox(height: screenHeight * 0.04),
                          AppButton(
                            text: 'Continue',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ChoosePlanScreen(),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: screenHeight * 0.02),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
