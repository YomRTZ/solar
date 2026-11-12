import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:flutter_app/core/widgets/app_continue_button.dart';
import 'package:flutter_app/core/widgets/app_header.dart';

class TransporterDeliveryStatusScreen extends StatelessWidget {
  const TransporterDeliveryStatusScreen({super.key});

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
            const AppHeader(title: 'Delivery Status', showBackButton: false),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(21, 28, 21, 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 104,
                      height: 104,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6F4DC),
                        borderRadius: BorderRadius.circular(34),
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        size: 64,
                        color: Color(0xFF0CAF00),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      'Delivered Successfully!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF008000),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Delivery Status has been updated successfully!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
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
          ],
        ),
      ),
    );
  }
}
