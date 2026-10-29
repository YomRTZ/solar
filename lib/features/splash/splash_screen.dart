import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../app/routing/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 8), () {
      if (mounted) {
        context.go(AppRoutes.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // ── Full-screen background ────────────────────────
          Positioned.fill(
            child: Image.asset(
              'assets/images/photo_5979016740496674867_y.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // ── Dark transparent overlay ──────────────────────
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.45),
                    Colors.black.withValues(alpha: 0.10),
                  ],
                ),
              ),
            ),
          ),

          // ── Content column ────────────────────────────────
          SizedBox(
            width: screenWidth,
            height: screenHeight,
            child: Column(
              children: [
                // Gap from status bar to logo top (~10% of height)
                SizedBox(height: screenHeight * 0.10),

                // Logo
                Image.asset(
                  'assets/images/a_clean_high_resolution_vector_like_logo_image_on.png',
                  width: screenWidth * 0.60,
                  height: screenWidth * 0.60,
                  fit: BoxFit.contain,
                ),

                // ── Gap between logo and text block (~3% of height) ──
                SizedBox(height: screenHeight * 0.03),

                // "Connecting"
                Text(
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

                const SizedBox(height: 6),

                // "Solar Supplier & Vendor"
                Text(
                  'Solar Supplier & Vendor',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    height: 1.0,
                    letterSpacing: 0,
                    color: const Color(0xFFFFFFFF),
                  ),
                ),

                const SizedBox(height: 12),

                // "A Trusted B2B Marketplace…"
                SizedBox(
                  width: screenWidth * 0.88,
                  child: Text(
                    'A Trusted B2B Marketplace For\nTransforming Trade Through Technology',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      height: 1.2,
                      letterSpacing: 0,
                      color: const Color(0xFFFFFFFF),
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
