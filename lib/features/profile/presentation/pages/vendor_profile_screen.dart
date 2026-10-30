import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_app/app/routing/app_routes.dart';

// Profile tab used inside [VendorMainScreen] (no back arrow — it's a root tab).
class VendorProfileScreen extends StatelessWidget {
  const VendorProfileScreen({super.key});

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
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _VendorProfileHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    // top padding leaves space for the avatar overlap
                    padding: const EdgeInsets.fromLTRB(20, 60, 17, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 28),
                        _buildBusinessCard(context),
                        const SizedBox(height: 16),
                        _buildLinkRow(
                          context,
                          icon: Icons.account_circle_outlined,
                          label: 'Account Details',
                          onTap: () => context.push(AppRoutes.vendorBankDetails),
                        ),
                        const SizedBox(height: 16),
                        _buildLinkRow(
                          context,
                          icon: Icons.description_outlined,
                          label: 'Documents',
                          onTap: () => context.push(AppRoutes.vendorUploadDocuments),
                        ),
                        const SizedBox(height: 16),
                        _buildLogoutRow(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ── Avatar circle ─────────────────────────────
            // top = header height + 31, left:132, right:138
            LayoutBuilder(
              builder: (context, constraints) {
                final statusBarHeight = MediaQuery.of(context).padding.top;
                final headerHeight = statusBarHeight + 80;
                final avatarTop = headerHeight + 31;
                return Stack(
                  children: [
                    // Avatar circle
                    Positioned(
                      top: avatarTop,
                      left: 132,
                      right: 138,
                      child: Container(
                        width: 84,
                        height: 84,
                        decoration: const BoxDecoration(
                          color: Color(0xFFD6E4F7),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'ST',
                          style: GoogleFonts.inter(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF003A8A),
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),

                    // ── "Solar Trade" name ──────────────────
                    // left:134.5, right:131.5, 12px below avatar
                    // bottom:2 gap before "Rahul Roy"
                    Positioned(
                      top: avatarTop + 84 + 12,
                      left: 134.5,
                      right: 131.5,
                      child: Text(
                        'Solar Trade',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                          letterSpacing: 16 * 0.002,
                          color: const Color(0xFF262422),
                        ),
                      ),
                    ),

                    // ── "Solar@gmail.com" email ────────────
                    // left:112, right:109, 2px below name (~19px name height)
                    Positioned(
                      top: avatarTop + 84 + 12 + 19 + 2,
                      left: 112,
                      right: 109,
                      child: Text(
                        'Solar@gmail.com',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          height: 1.2,
                          letterSpacing: 13 * 0.002,
                          color: const Color(0xFFABABAB),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEDF1F3)),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD6E4F7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.business_outlined,
                    color: Color(0xFF003A8A),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Business Information',
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                    letterSpacing: 0,
                    color: const Color(0xFF003A8A),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => context.push(AppRoutes.companyDetails),
                  child: Text(
                    'Edit',
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                      letterSpacing: 0,
                      color: const Color(0xFF003A8A),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEDF1F3)),
          _infoRow('Company Name', 'Solar Trade'),
          _infoRow('Email Address', 'Solar@gmail.com'),
          _infoRow('Address', '13-223 Saket, New Delhi'),
          _infoRow('Dispatch Location', '13-223 Saket, New Delhi'),
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          child: Stack(
            children: [
              // Label on the left
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  height: 1.6,
                  letterSpacing: 12 * -0.02,
                  color: const Color(0xFF6C7278),
                ),
              ),
              // Value fixed at left:170 from the row padding reference
              Positioned(
                left: 170 - 16, // subtract row horizontal padding
                top: 0,
                right: 0,
                child: Text(
                  value,
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 16 / 12,
                    letterSpacing: 0,
                    color: const Color(0xFF2A2A2A),
                  ),
                ),
              ),
              // Invisible spacer to give the row its natural height
              Opacity(
                opacity: 0,
                child: Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 1.6,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1, color: Color(0xFFEDF1F3)),
      ],
    );
  }

  Widget _buildLinkRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(40, 23, 103, 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFEDF1F3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFD6E4F7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF003A8A),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                height: 1.5,
                letterSpacing: 0,
                color: const Color(0xFF003A8A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutRow(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(AppRoutes.login),
      child: Container(
        padding: const EdgeInsets.fromLTRB(40, 23, 103, 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFEDF1F3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFD6E4F7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: Color(0xFF003A8A),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Logout',
              style: GoogleFonts.nunito(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                height: 1.5,
                letterSpacing: 0,
                color: const Color(0xFF003A8A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Header (no back arrow — root tab) ────────────────────────
class _VendorProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      height: top + 80,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF003A8A), Color(0xFF000F24)],
        ),
      ),
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Text(
        'My Profile',
        style: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: -0.4,
        ),
      ),
    );
  }
}
