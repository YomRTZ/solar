import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:flutter_app/core/widgets/second_app_header.dart';

/// Vendor profile screen — tab 4 of [VendorMainScreen].
/// Layout:
///   • Compact gradient header + "My Profile" title
///   • Centred avatar (ST initials) + Solar Trade + Solar@gmail.com
///   • Business Information card (Edit → company details)
///   • Account Details → bank details page
///   • Documents → upload documents page
///   • Logout row
class VendorProfileScreen extends StatelessWidget {
  final VoidCallback? onBackPressed;

  const VendorProfileScreen({super.key, this.onBackPressed});

  static const Color _blue = Color(0xFF003A8A);
  static const Color _avatarBg = Color(0xFFD6E4F7);
  static const Color _divider = Color(0xFFEDF1F3);

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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Header ──────────────────────────────────────
            SecondAppHeader(
              title: 'My Profile',
              onBackPressed: onBackPressed ?? () => context.go(AppRoutes.home),
            ),

            // ── Scrollable content ───────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Avatar ────────────────────────────────
                    _buildAvatar(),
                    const SizedBox(height: 24),

                    // ── Business Information card ─────────────
                    _buildBusinessCard(context),
                    const SizedBox(height: 20),

                    // ── Account Details ───────────────────────
                    _buildActionRow(
                      context,
                      icon: SizedBox(
                        width: 36,
                        height: 36,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 8,
                              top: 9,
                              child: Image.asset(
                                'assets/icons/account_details_icon.png',
                                width: 15,
                                height: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      label: 'Account Details',
                      onTap: () => context.push(AppRoutes.wallet),
                    ),

                    // ── Documents ─────────────────────────────
                    _buildActionRow(
                      context,
                      icon: const Icon(
                        Icons.description_outlined,
                        color: _blue,
                        size: 20,
                      ),
                      label: 'Documents',
                      onTap: () =>
                          context.push(AppRoutes.vendorUploadDocuments),
                    ),

                    // ── Logout ────────────────────────────────
                    _buildActionRow(
                      context,
                      icon: const Icon(
                        Icons.logout_rounded,
                        color: _blue,
                        size: 20,
                      ),
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
      ),
    );
  }

  // ── Centred avatar + name + email ─────────────────────────────
  Widget _buildAvatar() {
    return Column(
      children: [
        Container(
          width: 84,
          height: 84,
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
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF202020),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Solar@gmail.com',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF6C7278),
          ),
        ),
      ],
    );
  }

  // ── Business Information card ─────────────────────────────────
  Widget _buildBusinessCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.zero,
        border: Border(
          top: BorderSide(color: _divider),
          bottom: BorderSide(color: _divider),
        ),
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
          _infoRow('Company Name', 'Solar Trade'),
          _infoRow('Email Address', 'Solar@gmail.com'),
          _infoRow('Address', '13-223 Saket,\nNew Delhi'),
          _infoRow('Dispatch Location', '13-223 Saket,\nNew Delhi'),
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
                width: 173.2,
                child: Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 1.6,
                    letterSpacing: -0.24,
                    color: const Color(0xFF6C7278),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 16 / 12,
                    letterSpacing: 0,
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

  // ── Generic tappable action row ───────────────────────────────
  Widget _buildActionRow(
    BuildContext context, {
    required Widget icon,
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
                child: Center(child: icon),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF003A8A),
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
