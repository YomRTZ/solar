import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:flutter_app/core/widgets/app_continue_button.dart';
import 'package:flutter_app/core/widgets/second_app_header.dart';

class BidStatusScreen extends StatelessWidget {
  const BidStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const SecondAppHeader(title: 'Bid Status', showBackButton: false),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 82,
                        height: 82,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE7F5E0),
                          borderRadius: BorderRadius.circular(26),
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          size: 58,
                          color: Color(0xFF0FB900),
                        ),
                      ),
                      const SizedBox(height: 27),
                      Text(
                        'Bid Sent Successfully!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF008000),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your bid will be checked soon!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: const Color(0xFF808080),
                        ),
                      ),
                      const SizedBox(height: 26),
                      AppContinueButton(
                        text: 'Go to dashboard',
                        showArrow: false,
                        onPressed: () => context.go(AppRoutes.transporterHome),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
