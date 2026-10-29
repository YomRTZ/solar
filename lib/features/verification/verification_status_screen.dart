import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../app/routing/app_routes.dart';
import '../../core/widgets/app_header.dart';
import '../../core/widgets/app_continue_button.dart';

// ── Status enum ────────────────────────────────────────────────────────────
enum VerificationStatus { inProgress, approved, rejected }

// ─────────────────────────────────────────────────────────────────────────────
// Main Screen
// ─────────────────────────────────────────────────────────────────────────────
class VerificationStatusScreen extends StatelessWidget {
  final VerificationStatus status;

  /// Button callback for Approved → Continue
  final VoidCallback? onContinue;

  /// Button callback for Rejected → Update Details
  final VoidCallback? onUpdateDetails;

  /// Error detail shown only in rejected state
  /// e.g. "Invalid Gst Certificate"
  final String? errorDetail;

  const VerificationStatusScreen({
    super.key,
    required this.status,
    this.onContinue,
    this.onUpdateDetails,
    this.errorDetail,
  });

  // ── Convenience constructors ──────────────────────────────
  const VerificationStatusScreen.inProgress({super.key})
    : status = VerificationStatus.inProgress,
      onContinue = null,
      onUpdateDetails = null,
      errorDetail = null;

  const VerificationStatusScreen.approved({super.key, this.onContinue})
    : status = VerificationStatus.approved,
      onUpdateDetails = null,
      errorDetail = null;

  const VerificationStatusScreen.rejected({
    super.key,
    this.onUpdateDetails,
    this.errorDetail = 'Invalid Gst Certificate',
  }) : status = VerificationStatus.rejected,
       onContinue = null;

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
        extendBodyBehindAppBar: true,
        body: Column(
          children: [
            // ── Reusable gradient header ──────────────────
            AppHeader(
              title: 'Verification Status',
              height: 133,
              // Only show back on rejected screen
              showBackButton: status == VerificationStatus.rejected,
            ),

            // ── Status body ───────────────────────────────
            Expanded(child: _buildBody(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    switch (status) {
      case VerificationStatus.inProgress:
        return _InProgressBody();
      case VerificationStatus.approved:
        return _ApprovedBody(
          onContinue: onContinue ?? () => context.go(AppRoutes.home),
        );
      case VerificationStatus.rejected:
        return _RejectedBody(
          errorDetail: errorDetail ?? 'Invalid Gst Certificate',
          onUpdateDetails: onUpdateDetails ?? () => Navigator.pop(context),
        );
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STATE 1 — In Progress
// ─────────────────────────────────────────────────────────────────────────────
class _InProgressBody extends StatefulWidget {
  @override
  State<_InProgressBody> createState() => _InProgressBodyState();
}

class _InProgressBodyState extends State<_InProgressBody>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();

    // ── Pulse animation ───────────────────────────────────
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulse = Tween<double>(
      begin: 0.92,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // ── Auto-redirect to Approved after 3 seconds ─────────
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      context.go(AppRoutes.verificationApproved);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── Animated icon illustration ────────────────
            ScaleTransition(scale: _pulse, child: _buildIllustration()),
            const SizedBox(height: 32),

            // ── Title ─────────────────────────────────────
            Text(
              'Verification in Progress',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF003A8A),
                height: 1.3,
                letterSpacing: 20 * -0.02,
              ),
            ),
            const SizedBox(height: 12),

            // ── Subtitle ──────────────────────────────────
            Text(
              'We are verifying your documents\nand business details.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF808080),
                height: 1.3,
                letterSpacing: 14 * -0.02,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // PNG illustration for in-progress state
  Widget _buildIllustration() {
    return Image.asset(
      'assets/icons/image_1_1.png',
      width: 111,
      height: 111,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STATE 2 — Approved
// ─────────────────────────────────────────────────────────────────────────────
class _ApprovedBody extends StatelessWidget {
  final VoidCallback onContinue;
  const _ApprovedBody({required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── Approved PNG illustration ─────────────────────
          Image.asset(
            'assets/icons/image_1.png',
            width: 327,
            height: 111,
          ),
          const SizedBox(height: 16),

          // ── Title ─────────────────────────────────────────
          Text(
            'Account Approved!',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF008000),
              height: 1.3,
              letterSpacing: 20 * -0.02,
            ),
          ),
          const SizedBox(height: 10),

          // ── Subtitle ──────────────────────────────────────
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Your ',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF808080),
                    height: 1.3,
                    letterSpacing: 14 * -0.02,
                  ),
                ),
                TextSpan(
                  text: 'Supplier',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF808080),
                    height: 1.3,
                    letterSpacing: 14 * -0.02,
                  ),
                ),
                TextSpan(
                  text: ' account has been verified',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF808080),
                    height: 1.3,
                    letterSpacing: 14 * -0.02,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // ── Reusable Continue button ───────────────────────
          AppContinueButton(
            text: 'Continue',
            showArrow: false,
            onPressed: onContinue,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STATE 3 — Rejected / Action Required
// ─────────────────────────────────────────────────────────────────────────────
class _RejectedBody extends StatelessWidget {
  final String errorDetail;
  final VoidCallback onUpdateDetails;
  const _RejectedBody({
    required this.errorDetail,
    required this.onUpdateDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── Rejected PNG illustration ─────────────────────
          Image.asset(
            'assets/icons/image_1_2.png',
            width: 110,
            height: 110,
          ),
          const SizedBox(height: 32),

          // ── Title ─────────────────────────────────────────
          Text(
            'Action Required!',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFB31515),
            ),
          ),
          const SizedBox(height: 10),

          // ── Subtitle ──────────────────────────────────────
          Text(
            'Your application need corrections',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF6C7278),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 8),

          // ── Error detail (e.g. "Invalid Gst Certificate") ─
          Text(
            errorDetail,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFB31515),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 40),

          // ── Reusable Update Details button ────────────────
          AppContinueButton(
            text: 'Update Details',
            showArrow: false,
            onPressed: onUpdateDetails,
          ),
        ],
      ),
    );
  }
}
