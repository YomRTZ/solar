import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_app/app/routing/app_routes.dart';

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

          Positioned(
            left: 75,
            right: 65,
            top: 59,
            bottom: 497,
            child: Image.asset(
              'assets/images/a_clean_high_resolution_vector_like_logo_image_on.png',
              fit: BoxFit.contain,
            ),
          ),

          // ── Text block: stacked below logo ───────────────
          // Logo bottom edge = screen_height - 497
          // "Connecting"  : 14px below logo   → left:44, right:53
          // "Solar..."    : 10px below above   → left:59, right:45
          // "A Trusted…"  : 10px below above   → left:7,  right:6
          Positioned(
            top: MediaQuery.of(context).size.height - 497 + 14,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // "Connecting" — left:44, right:53
                Padding(
                  padding: const EdgeInsets.only(left: 44, right: 53),
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

                const SizedBox(height: 10),

                // "Solar Supplier & Vendor" — left:59, right:45
                Padding(
                  padding: const EdgeInsets.only(left: 59, right: 45),
                  child: Text(
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
                ),

                const SizedBox(height: 10),

                // "A Trusted B2B Marketplace…" — left:7, right:6
                Padding(
                  padding: const EdgeInsets.only(left: 7, right: 6),
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

