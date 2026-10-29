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
//  • White body with large success checkmark illustration
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
      padding: EdgeInsets.fromLTRB(24, 0, 24, bottom + 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),

          // ── Success / failure illustration ─────────────
          _StatusIllustration(isSuccess: isSuccess),

          const SizedBox(height: 32),

          // ── Headline ───────────────────────────────────
          Text(
            isSuccess ? 'RFQ Send Successfully!' : 'Submission Failed',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF003A8A),
              letterSpacing: -0.4,
            ),
          ),

          const SizedBox(height: 8),

          // ── Subtitle ───────────────────────────────────
          Text(
            isSuccess
                ? 'Your RFQ will be checked soon!'
                : 'Something went wrong. Please try again.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF6C7278),
            ),
          ),

          const Spacer(flex: 3),

          // ── Go to dashboard button ─────────────────────
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
// Status illustration — green ripple circle with checkmark (or X for failure)
// ─────────────────────────────────────────────────────────────────────────────
class _StatusIllustration extends StatelessWidget {
  final bool isSuccess;
  const _StatusIllustration({required this.isSuccess});

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
    final iconData = isSuccess ? Icons.check_rounded : Icons.close_rounded;

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
                      color: innerColor.withValues(alpha: 0.4),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(iconData, color: iconColor, size: 48),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
