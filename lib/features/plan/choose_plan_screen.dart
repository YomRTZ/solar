import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';

class ChoosePlanScreen extends StatefulWidget {
  const ChoosePlanScreen({super.key});

  @override
  State<ChoosePlanScreen> createState() => _ChoosePlanScreenState();
}

class _ChoosePlanScreenState extends State<ChoosePlanScreen> {
  String selectedPlan = 'month'; // 'month' or 'year'

  Widget _buildFeatureItem(String text, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            Icons.check_box,
            color: AppColors.primaryBlue,
            size: screenWidth * 0.055,
          ),
          SizedBox(width: screenWidth * 0.03),
          Text(
            text,
            style: GoogleFonts.roboto(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard({
    required String duration,
    required String price,
    String? savings,
    required bool isSelected,
    required VoidCallback onTap,
    required double screenWidth,
    required double screenHeight,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(screenWidth * 0.04),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? const Color(0xFF003D82) : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '3-Day Free Trial',
                        style: GoogleFonts.roboto(
                          fontSize: screenWidth * 0.032,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.005),
                      Text(
                        price,
                        style: GoogleFonts.roboto(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF003D82),
                        ),
                      ),
                      if (savings != null) ...[
                        SizedBox(height: screenHeight * 0.003),
                        Text(
                          savings,
                          style: GoogleFonts.roboto(
                            fontSize: screenWidth * 0.028,
                            fontWeight: FontWeight.w500,
                            color: Colors.green,
                          ),
                        ),
                      ],
                      SizedBox(height: screenHeight * 0.005),
                      Text(
                        duration,
                        style: GoogleFonts.roboto(
                          fontSize: screenWidth * 0.032,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? const Color(0xFF003D82) : Colors.grey[400]!,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF003D82),
                            ),
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background image with gradient overlay
          Positioned.fill(
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/photo_5979016740496674897_y.jpg',
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF003D82).withOpacity(0.85),
                        const Color(0xFF003D82).withOpacity(0.6),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Header section
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
                        'Choose a Plan',
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

                // Main content with white background
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
                          horizontal: screenWidth * 0.06,
                          vertical: screenHeight * 0.03,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Background image section at top
                            Container(
                              height: screenHeight * 0.15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: const DecorationImage(
                                  image: AssetImage('assets/images/photo_5979016740496674897_y.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.025),

                            // Features list
                            _buildFeatureItem('Access to RFQs', screenWidth),
                            _buildFeatureItem('Compare Products', screenWidth),
                            _buildFeatureItem('Place Orders', screenWidth),

                            SizedBox(height: screenHeight * 0.03),

                            // Plan cards
                            _buildPlanCard(
                              duration: 'Month',
                              price: 'Rs: 1,299/-',
                              isSelected: selectedPlan == 'month',
                              onTap: () {
                                setState(() {
                                  selectedPlan = 'month';
                                });
                              },
                              screenWidth: screenWidth,
                              screenHeight: screenHeight,
                            ),

                            SizedBox(height: screenHeight * 0.02),

                            _buildPlanCard(
                              duration: 'Year',
                              price: 'Rs: 12,999/-',
                              savings: 'Save Rs: 2589/-',
                              isSelected: selectedPlan == 'year',
                              onTap: () {
                                setState(() {
                                  selectedPlan = 'year';
                                });
                              },
                              screenWidth: screenWidth,
                              screenHeight: screenHeight,
                            ),

                            SizedBox(height: screenHeight * 0.04),

                            // Continue button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Handle continue action
                                  print('Selected Plan: $selectedPlan');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF003D82),
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

                            // Terms and Privacy links
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Terms of use',
                                    style: GoogleFonts.roboto(
                                      fontSize: screenWidth * 0.032,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                                Text(
                                  ' | ',
                                  style: TextStyle(color: Colors.grey[400]),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Privacy Policy',
                                    style: GoogleFonts.roboto(
                                      fontSize: screenWidth * 0.032,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
