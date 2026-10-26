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
    // Navigate to login page after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
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
    
    // Reference canvas width from design specs
    const referenceWidth = 361.0;
    const referenceHeight = 800.0;
    
    // Calculate scaling factors for responsive design
    final widthScale = screenWidth / referenceWidth;
    final heightScale = screenHeight / referenceHeight;
    
    // Use the smaller scale factor to maintain aspect ratio
    final scaleFactor = widthScale < heightScale ? widthScale : widthScale;
    
    // Calculate responsive logo size (between 100-160px depending on screen)
    final logoSize = screenWidth * 0.36;
    
    // Calculate responsive font sizes
    final mainTextSize = screenWidth * 0.061; // 24px base scaled
    final subtitleSize = screenWidth * 0.038; // 15px base scaled
    
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
          
          // Dark-Light-Dark-Transparent gradient overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.6),      // Dark at top
                    Colors.black.withOpacity(0.2),      // Light in upper-middle
                    Colors.black.withOpacity(0.5),      // Dark again in middle
                    Colors.transparent,                  // Transparent at bottom
                  ],
                  stops: const [0.0, 0.25, 0.55, 0.85],
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
                      // Logo section positioned in upper area
                      Positioned(
                        top: constraints.maxHeight * 0.08,
                        left: 0,
                        right: 0,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Complete logo with brand name and tagline (PNG with transparency)
                            Container(
                              width: logoSize * 1.3, // Larger for the complete logo
                              height: logoSize * 1.3,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/images/a_clean_high_resolution_vector_like_logo_image_on.png'),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Text section - positioned relative to screen height
                      Positioned(
                        top: constraints.maxHeight * 0.40, // 40% from top for better compatibility
                        left: 0,
                        right: 0,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Text element 1: "Connecting"
                            Text(
                              'Connecting',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w600,
                                fontSize: mainTextSize,
                                height: 1.0,
                                letterSpacing: 0,
                                color: Colors.white,
                              ),
                            ),
                            
                            SizedBox(height: screenHeight * 0.012),
                            
                            // Text element 2: "Solar Supplier & Vendor"
                            Text(
                              'Solar Supplier & Vendor',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w600,
                                fontSize: mainTextSize,
                                height: 1.0,
                                letterSpacing: 0,
                                color: Colors.white,
                              ),
                            ),
                            
                            SizedBox(height: screenHeight * 0.025),
                            
                            // Text element 3: Subtitle
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                              child: Text(
                                'A Trusted B2B Marketplace For Transforming Trade Through Technology',
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w500,
                                  fontSize: subtitleSize,
                                  height: 1.2,
                                  letterSpacing: 0,
                                  color: Colors.white.withOpacity(0.95),
                                ),
                              ),
                            ),
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
