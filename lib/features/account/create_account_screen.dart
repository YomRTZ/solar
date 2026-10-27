import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/widgets/app_text_field.dart';
import '../plan/choose_plan_screen.dart';

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
                final headerWidth = screenWidth < 327 ? screenWidth : 327.0;
                final screenHeight = MediaQuery.sizeOf(context).height;

                return Column(
                  children: [
                    Center(
                      child: SizedBox(
                        width: screenWidth,
                        height: 192,
                        child: DecoratedBox(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFF003A8A), Color(0xFF000F24)],
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 68,
                                left: (screenWidth - headerWidth) / 2,
                                width: headerWidth,
                                height: 90,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.arrow_back,
                                          color: Color(0xFFEEEEEE),
                                          size: 24,
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    SizedBox(
                                      width: headerWidth,
                                      height: 42,
                                      child: Text(
                                        'Create Account',
                                        maxLines: 1,
                                        style: GoogleFonts.inter(
                                          fontSize: 32,
                                          height: 1.3,
                                          letterSpacing: -0.64,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFFEEEEEE),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
                                  SizedBox(
                                    height: 48,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const ChoosePlanScreen(),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF003D82,
                                        ),
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        textStyle: GoogleFonts.inter(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text('Continue'),
                                          SizedBox(width: 8),
                                          Icon(
                                            Icons.arrow_forward_rounded,
                                            size: 18,
                                          ),
                                        ],
                                      ),
                                    ),
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
