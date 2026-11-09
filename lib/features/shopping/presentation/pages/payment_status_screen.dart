import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:flutter_app/core/widgets/app_continue_button.dart';
import 'package:flutter_app/core/widgets/app_header.dart';
import 'package:flutter_app/core/widgets/status_result_layout.dart';

class PaymentStatusScreen extends StatelessWidget {
  // Pass false to show the failure state.
  final bool isSuccess;

  const PaymentStatusScreen({super.key, this.isSuccess = true});

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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppHeader(title: 'Payment Status', showBackButton: false),
            Expanded(child: _buildBody(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StatusResultLayout(
      icon: Image.asset(
        isSuccess ? 'assets/icons/ic_status_success.png' : 'assets/icons/ic_status_failure.png',
        width: 111,
        height: 111,
        fit: BoxFit.contain,
      ),
      title: Text(
        isSuccess ? 'Payment Successful!' : 'Payment Failed!',
        textAlign: TextAlign.center,
        style: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: isSuccess ? const Color(0xFF008000) : const Color(0xFFB31515),
          height: 1.3,
          letterSpacing: -0.4,
        ),
      ),
      description: Text(
        isSuccess
            ? 'Your Order is placed Successfully'
            : 'Something went wrong. Please try again.',
        textAlign: TextAlign.center,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF808080),
          height: 1.3,
          letterSpacing: 14 * -0.02,
        ),
      ),
      button: AppContinueButton(
        text: 'Go to dashboard',
        showArrow: false,
        onPressed: () => context.go(AppRoutes.vendorMain),
      ),
    );
  }
}
