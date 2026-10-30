import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../app/routing/app_routes.dart';
import '../../core/widgets/app_continue_button.dart';
import '../../core/widgets/app_header.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AddTender — Payment Status Screen
//
// The status body follows the account-approved layout while retaining
// payment-specific messages and actions.
// ─────────────────────────────────────────────────────────────────────────────
class AddTenderPaymentStatusScreen extends StatelessWidget {
  /// Pass false to show the failure state.
  final bool isSuccess;

  const AddTenderPaymentStatusScreen({super.key, this.isSuccess = true});

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

  // ── Body ─────────────────────────────────────────────────────
  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            isSuccess
                ? 'assets/icons/image_1.png'
                : 'assets/icons/image_1_2.png',
            width: isSuccess ? 327 : 110,
            height: 111,
            fit: BoxFit.contain,
          ),
          SizedBox(height: isSuccess ? 16 : 32),

          // ── Headline ──────────────────────────────────
          Text(
            isSuccess ? 'Payment Successful!' : 'Payment Failed!',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: isSuccess
                  ? const Color(0xFF008000)
                  : const Color(0xFFB31515),
              height: 1.3,
              letterSpacing: 20 * -0.02,
            ),
          ),

          const SizedBox(height: 10),

          // ── Subtitle ──────────────────────────────────
          Text(
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

          const SizedBox(height: 40),

          // ── Go to dashboard ────────────────────────────
          AppContinueButton(
            text: 'Go to dashboard',
            showArrow: false,
            onPressed: () => context.go(AppRoutes.tenderMain),
          ),
        ],
      ),
    );
  }
}
