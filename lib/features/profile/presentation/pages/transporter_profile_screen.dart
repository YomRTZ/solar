import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:flutter_app/core/widgets/second_app_header.dart';

class TransporterProfileScreen extends StatelessWidget {
  const TransporterProfileScreen({super.key});

  static const _blue = Color(0xFF003A8A);
  static const _avatarBackground = Color(0xFFD6E4F7);
  static const _divider = Color(0xFFEDF1F3);

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
          children: [
            SecondAppHeader(
              title: 'My Profile',
              onBackPressed: () => context.go(AppRoutes.transporterHome),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildAvatar(),
                    const SizedBox(height: 28),
                    _buildInformationCard(),
                    const SizedBox(height: 24),
                    _buildLinkRow(
                      context,
                      icon: Icons.receipt_long_outlined,
                      label: 'My Bids',
                      onTap: () => context.push(AppRoutes.transporterMyBids),
                    ),
                    _buildLinkRow(
                      context,
                      icon: Icons.local_shipping_outlined,
                      label: 'My Trips',
                      onTap: () => context.push(AppRoutes.transporterMyTrips),
                    ),
                    const SizedBox(height: 16),
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
      ),
    );
  }

  Widget _buildAvatar() {
    return Column(
      children: [
        Container(
          width: 84,
          height: 84,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            color: _avatarBackground,
            shape: BoxShape.circle,
          ),
          child: Image.asset(
            'assets/solarimages/avater.png',
            key: const ValueKey('transporter-profile-avatar'),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.person,
              color: _blue,
              size: 44,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Transporter',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF202020),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Transport Partner',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF6C7278),
          ),
        ),
      ],
    );
  }

  Widget _buildInformationCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _avatarBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.local_shipping_outlined,
                    color: _blue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Transporter Information',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: _blue,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: _divider),
          _infoRow('Full Name', 'Not provided'),
          _infoRow('Vehicle Type', 'Open Truck'),
          _infoRow('Vehicle Number', 'Not provided'),
          _infoRow('DL Number', 'Not provided'),
          _infoRow('Mobile Number', 'Not provided'),
          _infoRow('State / City', 'Not provided'),
          _infoRow('Pincode', 'Not provided', isLast: true),
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
                  color: _avatarBackground,
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
                    color: _blue,
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
