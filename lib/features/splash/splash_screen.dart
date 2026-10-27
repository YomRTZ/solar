import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to login page after 8 seconds
    Future.delayed(const Duration(seconds: 8), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate responsive font sizes
    final mainTextSize = screenWidth * 0.061; // 24px base scaled

    return Scaffold(
      body: Stack(
        children: [
          // Background image - full screen
          Positioned.fill(
            child: Image.asset(
              'assets/images/photo_5979016740496674867_y.jpg',
              fit: BoxFit.cover,
            ),
          ),

          Positioned(
            top: 59,
            left: 75,
            child: Image.asset(
              'assets/images/a_clean_high_resolution_vector_like_logo_image_on.png',
              width: 220,
              height: 244,
              fit: BoxFit.contain,
            ),
          ),

          Positioned(
            top: 297,
            left: 119,
            child: SizedBox(
              width: 123,
              height: 28,
              child: Center(
                child: Text(
                  'Connecting',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    height: 1.0,
                    letterSpacing: 0,
                    color: const Color(0xFFFFFFFF),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: 335,
            left: 57,
            child: SizedBox(
              width: 256,
              height: 28,
              child: Center(
                child: Text(
                  'Solar Supplier & Vendor',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  softWrap: false,
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    height: 1.0,
                    letterSpacing: 0,
                    color: const Color(0xFFFFFFFF),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: 373,
            left: 48,
            child: SizedBox(
              width: 274,
              height: 36,
              child: Center(
                child: Text(
                  'A Trusted B2B Marketplace For\nTransforming Trade Through Technology',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    height: 1.0,
                    letterSpacing: 0,
                    color: const Color(0xFFFFFFFF),
                  ),
                ),
              ),
            ),
          ),

          // Main content with absolute positioning
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: Stack(
                    children: [
                      // Text section - positioned relative to screen height
                      Positioned(
                        top:
                            constraints.maxHeight *
                            0.40, // 40% from top for better compatibility
                        left: 0,
                        right: 0,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Text element 1: "Connecting"
                            SizedBox(height: mainTextSize),

                            SizedBox(height: screenHeight * 0.012),

                            // Text element 2: "Solar Supplier & Vendor"
                            const SizedBox(height: 28),

                            SizedBox(height: screenHeight * 0.025),

                            // Text element 3: Subtitle
                            const SizedBox(height: 36),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
