import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/widgets/app_continue_button.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF003A8A),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                child: Column(
                  children: [
                    // ── Avatar ───────────────────────────────
                    _buildAvatar(),
                    const SizedBox(height: 24),

                    // ── Info tiles ───────────────────────────
                    _buildInfoTile(
                        icon: Icons.business_rounded,
                        label: 'Company',
                        value: 'Solar Trade'),
                    _buildDivider(),
                    _buildInfoTile(
                        icon: Icons.email_outlined,
                        label: 'Email',
                        value: 'Solar@gmail.com'),
                    _buildDivider(),
                    _buildInfoTile(
                        icon: Icons.phone_outlined,
                        label: 'Mobile',
                        value: '+91 9876543210'),
                    _buildDivider(),
                    _buildInfoTile(
                        icon: Icons.location_on_outlined,
                        label: 'Address',
                        value: '12-223 Saket, New Delhi'),
                    _buildDivider(),
                    _buildInfoTile(
                        icon: Icons.receipt_long_outlined,
                        label: 'GST Number',
                        value: '08TGC45879'),
                    _buildDivider(),
                    _buildInfoTile(
                        icon: Icons.credit_card_outlined,
                        label: 'PAN Number',
                        value: '123456789'),
                    const SizedBox(height: 32),

                    // ── Menu items ───────────────────────────
                    _buildMenuItem(
                      context,
                      icon: Icons.edit_outlined,
                      label: 'Edit Profile',
                      onTap: () {},
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.lock_outline_rounded,
                      label: 'Change Password',
                      onTap: () {},
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.help_outline_rounded,
                      label: 'Help & Support',
                      onTap: () {},
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.info_outline_rounded,
                      label: 'About App',
                      onTap: () {},
                    ),
                    const SizedBox(height: 32),

                    // ── Logout button ────────────────────────
                    AppContinueButton(
                      text: 'Logout',
                      showArrow: false,
                      backgroundColor: Colors.white,
                      textColor: const Color(0xFFB31515),
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()),
                          (route) => false,
                        );
                      },
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

  // ── Header ────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF003A8A), Color(0xFF000F24)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Text(
            'Profile',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // ── Avatar ────────────────────────────────────────────────
  Widget _buildAvatar() {
    return Column(
      children: [
        Container(
          width: 84,
          height: 84,
          decoration: const BoxDecoration(
            color: Color(0xFFE8F0FE),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person_rounded,
            size: 48,
            color: Color(0xFF003A8A),
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
          'Supplier',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF003A8A),
          ),
        ),
      ],
    );
  }

  // ── Info tile ─────────────────────────────────────────────
  Widget _buildInfoTile(
      {required IconData icon,
      required String label,
      required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF003A8A)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: const Color(0xFF6C7278),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF202020),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() => const Divider(height: 1, color: Color(0xFFF0F0F0));

  // ── Menu item ─────────────────────────────────────────────
  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: const Color(0xFF003A8A)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF202020),
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                size: 20, color: Color(0xFF6C7278)),
          ],
        ),
      ),
    );
  }
}
