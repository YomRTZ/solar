import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:flutter_app/core/widgets/second_app_header.dart';

class TransporterProfileScreen extends StatelessWidget {
  const TransporterProfileScreen({super.key});

  static const _blue = Color(0xFF003A8A);
  static const _avatarRing = Color(0xFFE8D0D0);
  static const _divider = Color(0xFFEDF1F3);
  static const _labelColor = Color(0xFF6C7278);
  static const _valueColor = Color(0xFF1A1C1E);

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
        backgroundColor: const Color(0xFFF5F5F5),
        body: Column(
          children: [
            SecondAppHeader(
              title: 'My Profile',
              onBackPressed: () => context.go(AppRoutes.transporterHome),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildAvatarSection(),
                    const SizedBox(height: 20),
                    _buildDriverInfoCard(context),
                    const SizedBox(height: 24),
                    _buildLogoutRow(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _avatarRing, width: 3),
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/solarimages/avater.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: const Color(0xFFD6E4F7),
                child: const Icon(Icons.person, color: _blue, size: 44),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Rishabh Khurana',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: _valueColor,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Open Truck, Container',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: _labelColor,
          ),
        ),
      ],
    );
  }

  Widget _buildDriverInfoCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBF0FB),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.grid_view_rounded,
                    color: _blue,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Driver Information',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _blue,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => context.push(AppRoutes.transporterCreateAccount),
                  child: Text(
                    'Edit',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: _blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: _divider),
          _infoRow('Full Name', 'Rishabh Khurana'),
          _infoRow('Vehicle Number', 'DL 3C BB 3433'),
          _infoRow('DL Number', '1223048034909'),
          const Divider(height: 8, thickness: 8, color: Color(0xFFF5F5F5)),
          _infoRow('Mobile Number', '9876546879'),
          _infoRow('State/City', 'New Delhi'),
          _infoRow('Pincode', '12345678'),
          _infoRow('List of vehicles', 'Open Truck, Container', isLast: true),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool isLast = false}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 173.2,
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: _labelColor,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _valueColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1, thickness: 1, color: _divider),
      ],
    );
  }

  Widget _buildLogoutRow(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => context.go(AppRoutes.login),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFEBF0FB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: _blue,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Logout',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _valueColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
