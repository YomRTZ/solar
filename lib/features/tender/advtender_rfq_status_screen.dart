import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../app/routing/app_routes.dart';
import '../../core/widgets/app_continue_button.dart';
import '../../core/widgets/app_header.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AdvTender — RFQ Status Screen
//
// Layout:
//  • Dark-gradient top section with "RFQ Status" title
//  • White body with the account status illustration
//  • "RFQ Send Successfully!" headline + subtitle
//  • "Go to dashboard" button
// ─────────────────────────────────────────────────────────────────────────────
class AdvTenderRfqStatusScreen extends StatelessWidget {
  /// Whether the RFQ was sent successfully (default: true).
  /// Pass false to show a failure state.
  final bool isSuccess;

  const AdvTenderRfqStatusScreen({super.key, this.isSuccess = true});

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
            const AppHeader(title: 'RFQ Status', showBackButton: false),
            Expanded(child: _buildBody(context)),
          ],
        ),
      ),
    );
  }

  // ── Main body ──────────────────────────────────────────────
  Widget _buildBody(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(32, 0, 32, bottom + 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _StatusIllustration(isSuccess: isSuccess),

          SizedBox(height: isSuccess ? 16 : 32),

          Text(
            isSuccess ? 'RFQ Send Successfully!' : 'Submission Failed',
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

          Text(
            isSuccess
                ? 'Your RFQ will be checked soon!'
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
// Uses the same illustrations as the account approval and rejection states.
// ─────────────────────────────────────────────────────────────────────────────
class _StatusIllustration extends StatelessWidget {
  final bool isSuccess;
  const _StatusIllustration({required this.isSuccess});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      isSuccess ? 'assets/icons/image_1.png' : 'assets/icons/image_1_2.png',
      width: isSuccess ? 327 : 110,
      height: 111,
      fit: BoxFit.contain,
    );
  }
}
