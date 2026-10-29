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
// Layout:
//  • Dark-gradient top banner with "Payment Status" title
//  • White body with triple-ring green checkmark illustration
//  • "Payment Successful!" / "Payment Failed" headline + subtitle
//  • "Go to dashboard" AppContinueButton
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
    final bottom = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 0, 24, bottom + 24),
      child: Column(
        children: [
          const Spacer(flex: 2),

          // ── Ripple illustration ───────────────────────
          _PaymentIllustration(isSuccess: isSuccess),

          const SizedBox(height: 32),

          // ── Headline ──────────────────────────────────
          Text(
            isSuccess ? 'Payment Successful!' : 'Payment Failed!',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: isSuccess
                  ? const Color(0xFF27AE60)
                  : const Color(0xFFE74C3C),
              letterSpacing: -0.4,
            ),
          ),

          const SizedBox(height: 8),

          // ── Subtitle ──────────────────────────────────
          Text(
            isSuccess
                ? 'Your Order is placed Successfully'
                : 'Something went wrong. Please try again.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF6C7278),
            ),
          ),

          const Spacer(flex: 3),

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

// ─────────────────────────────────────────────────────────────────────────────
// Triple-ring illustration (reused from advtender status screen, self-contained)
// ─────────────────────────────────────────────────────────────────────────────
class _PaymentIllustration extends StatelessWidget {
  final bool isSuccess;
  const _PaymentIllustration({required this.isSuccess});

  @override
  Widget build(BuildContext context) {
    final outerColor = isSuccess
        ? const Color(0xFFD1FAE5)
        : const Color(0xFFFFE4E6);
    final midColor = isSuccess
        ? const Color(0xFF6EE7B7)
        : const Color(0xFFFCA5A5);
    final innerColor = isSuccess
        ? const Color(0xFF34D399)
        : const Color(0xFFF87171);
    final iconColor = isSuccess
        ? const Color(0xFF065F46)
        : const Color(0xFF9F1239);

    return Center(
      child: Container(
        width: 160,
        height: 160,
        decoration: BoxDecoration(color: outerColor, shape: BoxShape.circle),
        child: Center(
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(color: midColor, shape: BoxShape.circle),
            child: Center(
              child: Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: innerColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: innerColor.withValues(alpha: 0.45),
                      blurRadius: 18,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  isSuccess ? Icons.check_rounded : Icons.close_rounded,
                  color: iconColor,
                  size: 50,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
