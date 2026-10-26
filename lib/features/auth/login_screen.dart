import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import 'otp_verification_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String selectedRole = 'Supplier';
  final TextEditingController mobileController = TextEditingController();

  @override
  void dispose() {
    mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.08,
                    vertical: screenHeight * 0.04,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo
                      Container(
                        width: screenWidth * 0.5,
                        height: screenWidth * 0.5,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/photo_5979016740496674893_x.jpg'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.02),

                      // Welcome Back! heading
                      Text(
                        'Welcome Back!',
                        style: GoogleFonts.roboto(
                          fontSize: screenWidth * 0.065,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryBlue,
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.01),

                      // Subtitle
                      Text(
                        'Login to your Solar TradeXHub account',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textGrey,
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      // Supplier / Vendor toggle buttons
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedRole = 'Supplier';
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.015,
                                ),
                                decoration: BoxDecoration(
                                  color: selectedRole == 'Supplier'
                                      ? AppColors.primaryBlue
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: AppColors.primaryBlue,
                                    width: 1.5,
                                  ),
                                ),
                                child: Text(
                                  'Supplier',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.roboto(
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.w600,
                                    color: selectedRole == 'Supplier'
                                        ? Colors.white
                                        : AppColors.primaryBlue,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.04),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedRole = 'Vendor';
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.015,
                                ),
                                decoration: BoxDecoration(
                                  color: selectedRole == 'Vendor'
                                      ? AppColors.primaryBlue
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: AppColors.primaryBlue,
                                    width: 1.5,
                                  ),
                                ),
                                child: Text(
                                  'Vendor',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.roboto(
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.w600,
                                    color: selectedRole == 'Vendor'
                                        ? Colors.white
                                        : AppColors.primaryBlue,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      // Mobile Number label
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Mobile Number',
                          style: GoogleFonts.roboto(
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.01),

                      // Mobile Number input field
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.inputBackground,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.borderGrey,
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: mobileController,
                          keyboardType: TextInputType.phone,
                          style: GoogleFonts.roboto(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            hintText: '+91 9899 333 112',
                            hintStyle: GoogleFonts.roboto(
                              fontSize: screenWidth * 0.04,
                              color: AppColors.textGreyLight,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                              vertical: screenHeight * 0.018,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.04),

                      // Continue button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OtpVerificationScreen(
                                  mobileNumber: mobileController.text.isEmpty 
                                    ? '+91 9899 333 112' 
                                    : mobileController.text,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.02,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Continue',
                            style: GoogleFonts.roboto(
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
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
      ),
    );
  }
}
