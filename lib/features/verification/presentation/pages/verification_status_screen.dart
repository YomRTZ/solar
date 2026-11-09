import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:flutter_app/core/widgets/app_header.dart';
import 'package:flutter_app/core/widgets/app_continue_button.dart';
import 'package:flutter_app/core/widgets/status_result_layout.dart';

enum VerificationStatus { inProgress, approved, rejected }

class VerificationStatusScreen extends StatelessWidget {
  final VerificationStatus status;
  final VoidCallback? onContinue;
  final VoidCallback? onUpdateDetails;
  final String? errorDetail;

  const VerificationStatusScreen({
    super.key,
    required this.status,
    this.onContinue,
    this.onUpdateDetails,
    this.errorDetail,
  });

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
            AppHeader(
              title: 'Verification Status',
              height: 133,
              showBackButton: status == VerificationStatus.rejected,
            ),
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

class _StatusLayout extends StatelessWidget {
  final Widget icon;
  final Widget title;
  final Widget description;
  final Widget? button;

  const _StatusLayout({
    required this.icon,
    required this.title,
    required this.description,
    this.button,
  });

  @override
  Widget build(BuildContext context) {
    return StatusResultLayout(
      icon: icon,
      title: title,
      description: description,
      button: button,
    );
  }
}

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
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulse = Tween<double>(
      begin: 0.92,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

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
    return _StatusLayout(
      icon: ScaleTransition(
        scale: _pulse,
        child: Image.asset(
          'assets/icons/ic_status_verification_pending.png',
          width: 111,
          height: 111,
          fit: BoxFit.contain,
        ),
      ),
      title: Text(
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
      description: Text(
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
    );
  }
}

class _ApprovedBody extends StatelessWidget {
  final VoidCallback onContinue;
  const _ApprovedBody({required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return _StatusLayout(
      icon: Image.asset(
        'assets/icons/ic_status_success.png',
        width: 111,
        height: 111,
        fit: BoxFit.contain,
      ),
      title: Text(
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
      description: RichText(
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
                fontWeight: FontWeight.w500,
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
      button: AppContinueButton(
        text: 'Continue',
        showArrow: false,
        onPressed: onContinue,
      ),
    );
  }
}

class _RejectedBody extends StatelessWidget {
  final String errorDetail;
  final VoidCallback onUpdateDetails;
  const _RejectedBody({
    required this.errorDetail,
    required this.onUpdateDetails,
  });

  @override
  Widget build(BuildContext context) {
    return _StatusLayout(
      icon: Image.asset(
        'assets/icons/ic_status_failure.png',
        width: 111,
        height: 111,
        fit: BoxFit.contain,
      ),
      title: Text(
        'Action Required!',
        textAlign: TextAlign.center,
        style: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: const Color(0xFFB31515),
          height: 1.3,
          letterSpacing: 20 * -0.02,
        ),
      ),
      description: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Your application need corrections',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6C7278),
              height: 1.3,
              letterSpacing: 14 * -0.02,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            errorDetail,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFB31515),
              height: 1.3,
              letterSpacing: 14 * -0.02,
            ),
          ),
        ],
      ),
      button: AppContinueButton(
        text: 'Update Details',
        showArrow: false,
        onPressed: onUpdateDetails,
      ),
    );
  }
}
