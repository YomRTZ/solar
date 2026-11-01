import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_app/app/routing/app_routes.dart';

/// Supplier profile screen — tab 4 of [HomeScreen].
/// Layout:
///   • Dark gradient header with "My Profile" title
///   • Avatar circle overlapping header/body boundary
///   • Solar Trade + Rahul Roy labels below avatar
///   • Business Information card (Edit → company details)
///   • Account Details → My Wallet
///   • Logout row
class SupplierProfileScreen extends StatelessWidget {
  final VoidCallback? onBackPressed;

  const SupplierProfileScreen({super.key, this.onBackPressed});

  static const Color _blue = Color(0xFF003A8A);
  static const Color _avatarBg = Color(0xFFD6E4F7);
  static const Color _divider = Color(0xFFEDF1F3);

  @override
  Widget build(BuildContext context) {
    final statusBarH = MediaQuery.of(context).padding.top;
    // Header height: status bar + 80 px of content
    const double headerContentH = 80;
    final double headerH = statusBarH + headerContentH;
    // Avatar sits half above / half below the header bottom edge
    const double avatarSize = 84.0;
    final double avatarTop = headerH - avatarSize / 2;

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
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Gradient header ────────────────────────
                _SupplierProfileHeader(
                  height: headerH,
                  onBackPressed:
                      onBackPressed ?? () => context.go(AppRoutes.vendorMain),
                ),

                // ── Scrollable body ────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    // Leave room for the avatar + name/contact block
                    padding: EdgeInsets.fromLTRB(
                      20,
                      avatarSize / 2 + 12 + 22 + 4 + 18 + 31,
                      20,
                      32,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ── Business Information card ────────
                        _buildBusinessCard(context),
                        const SizedBox(height: 107),

                        // ── Logout ───────────────────────────
                        _buildLinkRow(
                          context,
                          icon: Icons.logout_rounded,
                          label: 'Logout',
                          onTap: () => context.go(AppRoutes.login),
                          showArrow: false,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ── Overlapping avatar + name + contact ────────
            Positioned(
              top: avatarTop,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  // Avatar circle
                  Container(
                    width: avatarSize,
                    height: avatarSize,
                    decoration: const BoxDecoration(
                      color: _avatarBg,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'ST',
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: _blue,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Solar Trade',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF202020),
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rahul Roy',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF6C7278),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Business Information card ─────────────────────────────────
  Widget _buildBusinessCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.zero,
        border: Border.all(color: _divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Section header ─────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _avatarBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.business_outlined,
                    color: _blue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Business Information',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: _blue,
                  ),
                ),
                const Spacer(),
                // Edit → Company Details page
                GestureDetector(
                  onTap: () => context.push(AppRoutes.companyDetails),
                  child: Text(
                    'Edit',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: _divider),

          // ── Info rows ──────────────────────────────────────
          _infoRow('Business', 'Solar Trade Rahul Roy'),
          _infoRow('Contact Person', 'Rahul Roy'),
          _infoRow('Address', '13-223 Saket,\nNew Delhi'),
          _infoRow('Gst Number', '9876546879'),
          _infoRow('Pan Number', '12345678', isLast: true),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool isLast = false}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 140,
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF6C7278),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF202020),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1, color: _divider),
      ],
    );
  }

  // ── Generic tappable link row ─────────────────────────────────
  Widget _buildLinkRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool showArrow = true,
  }) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: _divider)),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _avatarBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: _blue, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF202020),
                  ),
                ),
              ),
              if (showArrow)
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Color(0xFF6C7278),
                  size: 14,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Gradient header widget ────────────────────────────────────
class _SupplierProfileHeader extends StatelessWidget {
  final double height;
  final VoidCallback onBackPressed;

  const _SupplierProfileHeader({
    required this.height,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF003A8A), Color(0xFF000F24)],
        ),
      ),
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.fromLTRB(16, 0, 20, 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBackPressed,
            child: SvgPicture.asset(
              'assets/icons/arrow-narrow-left.svg',
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'My Profile',
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.4,
            ),
          ),
        ],
      ),
    );
  }
}
