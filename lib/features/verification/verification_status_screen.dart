import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/widgets/app_header.dart';
import '../../core/widgets/app_continue_button.dart';
import '../home/home_screen.dart';

// ── Status enum ────────────────────────────────────────────────────────────
enum VerificationStatus {
  inProgress,
  approved,
  rejected,
}

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

  const VerificationStatusScreen.approved({
    super.key,
    this.onContinue,
  })  : status = VerificationStatus.approved,
        onUpdateDetails = null,
        errorDetail = null;

  const VerificationStatusScreen.rejected({
    super.key,
    this.onUpdateDetails,
    this.errorDetail = 'Invalid Gst Certificate',
  })  : status = VerificationStatus.rejected,
        onContinue = null;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF003A8A),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // ── Reusable gradient header ──────────────────
            AppHeader(
              title: 'Verification Status',
              // Only show back on rejected screen
              showBackButton: status == VerificationStatus.rejected,
            ),

            // ── Status body ───────────────────────────────
            Expanded(
              child: _buildBody(context),
            ),
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
          onContinue: onContinue ??
              () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                    (route) => false,
                  ),
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

    _pulse = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // ── Auto-redirect to Approved after 3 seconds ─────────
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          // No onContinue passed — the approved screen's _buildBody
          // fallback uses its own fresh context to go to HomeScreen
          builder: (_) => const VerificationStatusScreen.approved(),
        ),
      );
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
            ScaleTransition(
              scale: _pulse,
              child: _buildIllustration(),
            ),
            const SizedBox(height: 32),

            // ── Title ─────────────────────────────────────
            Text(
              'Verification in Progress',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF003A8A),
              ),
            ),
            const SizedBox(height: 12),

            // ── Subtitle ──────────────────────────────────
            Text(
              'We are verifying your documents\nand business details.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF6C7278),
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Custom document + clock illustration matching the screenshot
  Widget _buildIllustration() {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Document body
          Positioned(
            bottom: 0,
            left: 10,
            child: Container(
              width: 78,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8EE),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFE8A84C),
                  width: 2.5,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 28, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    4,
                    (i) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Container(
                        height: 4,
                        width: i == 3 ? 30 : double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8A84C).withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Dog-ear on document
          Positioned(
            bottom: 72,
            left: 10,
            child: ClipPath(
              clipper: _DogEarClipper(),
              child: Container(
                width: 20,
                height: 20,
                color: const Color(0xFFE8A84C),
              ),
            ),
          ),

          // Clock circle
          Positioned(
            top: 0,
            right: 8,
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF003A8A),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Icon(
                Icons.access_time_rounded,
                color: Color(0xFF003A8A),
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Clipper for the dog-ear fold effect
class _DogEarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(_DogEarClipper old) => false;
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
          // ── Green check circle ────────────────────────────
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: const Color(0xFFE6F9EF),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
                width: 6,
              ),
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Color(0xFF217552),
              size: 60,
            ),
          ),
          const SizedBox(height: 32),

          // ── Title ─────────────────────────────────────────
          Text(
            'Account Approved!',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF217552),
            ),
          ),
          const SizedBox(height: 10),

          // ── Subtitle ──────────────────────────────────────
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF6C7278),
                height: 1.6,
              ),
              children: const [
                TextSpan(text: 'Your '),
                TextSpan(
                  text: 'Supplier',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF202020),
                  ),
                ),
                TextSpan(text: ' account has been verified'),
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
  const _RejectedBody(
      {required this.errorDetail, required this.onUpdateDetails});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── Red X circle ──────────────────────────────────
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: const Color(0xFFFFEBEB),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFB31515).withValues(alpha: 0.25),
                width: 6,
              ),
            ),
            child: const Icon(
              Icons.close_rounded,
              color: Color(0xFFB31515),
              size: 60,
            ),
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
