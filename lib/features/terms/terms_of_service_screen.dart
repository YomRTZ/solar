import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/widgets/app_header.dart';
import '../../core/widgets/app_continue_button.dart';

class TermsOfServiceScreen extends StatelessWidget {
  /// Called when the user taps Accept
  final VoidCallback? onAccept;

  /// Called when the user taps Decline
  final VoidCallback? onDecline;

  const TermsOfServiceScreen({
    super.key,
    this.onAccept,
    this.onDecline,
  });

  // ── Terms content data ──────────────────────────────────────
  static const List<_TermsSection> _sections = [
    _TermsSection(
      title: '1. Terms',
      paragraph:
          'Tellus at sit ante rutrum suspendisse pretium, vitae vel dignissim. '
          'Nunc, scelerisque adipiscing condimentum massa dignissim tortor leo '
          'lacus. Sapien felis ultrices fringilla nisi sit nibh. Etiam volutpat '
          'nisl ornare lorem mus at a, et pulvinar.',
      bullets: [],
    ),
    _TermsSection(
      title: '2. Use License',
      paragraph:
          'Fermentum erat nisl duis varius risus. Augue ac facilisi porta metus '
          'enim. Ullamcorper lacus praesent rhoncus, sapien rutrum nulla mattis '
          'vitae ultrices.',
      bullets: [
        'Fermentum erat nisl duis varius risus.',
        'Augue ac facilisi porta metus enim.',
        'Ullamcorper lacus praesent rhoncus, sapien rutrum nulla mattis vitae ultrices.',
        'Nunc, scelerisque adipiscing condimentum massa dignissim tortor leo lacus.',
      ],
    ),
    _TermsSection(
      title: '3. Disclaimer',
      paragraph:
          'Consequat adipiscing elementum amet condimentum. Nibh hendrerit '
          'cursus aliquam porttitor velit. Tempor cras eget leo sapien nunc '
          'egestas cursus. Consequat orci urna, purus sed lorem amet.',
      bullets: [],
    ),
    _TermsSection(
      title: '4. Limitations',
      paragraph:
          'In viverra arcu vulputate vestibulum. Purus duis porttitor '
          'condimentum velit faucibus pretium. Feugiat proin amet nullam '
          'blandit iaculis massa. Urna morbi enim donec et velit.',
      bullets: [],
    ),
    _TermsSection(
      title: '5. Privacy Policy',
      paragraph:
          'Ac etiam bibendum morbi nunc volutpat. Non eget facilisi dui morbi '
          'volutpat. Amet viverra blandit et malesuada volutpat. Vitae '
          'sollicitudin orci dictumst quis diam amet at.',
      bullets: [],
    ),
  ];

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
            // ── Reusable gradient header ──────────────────────
            const AppHeader(title: 'Terms of Service', height: 133),

            // ── Scrollable content ────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _sections
                      .map((section) => _buildSection(section))
                      .toList(),
                ),
              ),
            ),

            // ── Bottom action buttons ─────────────────────────
            _buildBottomButtons(context),
          ],
        ),
      ),
    );
  }

  // ── Single terms section ──────────────────────────────────
  Widget _buildSection(_TermsSection section) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            section.title,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF202020),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),

          // Paragraph
          if (section.paragraph.isNotEmpty)
            Text(
              section.paragraph,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF4A4A4A),
                height: 1.6,
              ),
            ),

          // Bullet list
          if (section.bullets.isNotEmpty) ...[
            const SizedBox(height: 10),
            ...section.bullets.map(
              (bullet) => _buildBullet(bullet),
            ),
          ],
        ],
      ),
    );
  }

  // ── Individual bullet row ─────────────────────────────────
  Widget _buildBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bullet dot
          Padding(
            padding: const EdgeInsets.only(top: 6, right: 10),
            child: Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                color: Color(0xFF4A4A4A),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Bullet text
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF4A4A4A),
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Decline + Accept buttons ──────────────────────────────
  Widget _buildBottomButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Decline (outlined) ──────────────────────────
          Expanded(
            child: SizedBox(
              height: 48,
              child: OutlinedButton(
                onPressed: onDecline ?? () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: Color(0xFF003D82),
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  foregroundColor: const Color(0xFF003D82),
                  backgroundColor: Colors.white,
                  elevation: 0,
                ),
                child: Text(
                  'Decline',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF003D82),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // ── Accept (reusable filled button) ────────────
          Expanded(
            child: AppContinueButton(
              text: 'Accept',
              showArrow: false,
              onPressed: onAccept ?? () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Data class for a terms section ──────────────────────────
class _TermsSection {
  final String title;
  final String paragraph;
  final List<String> bullets;

  const _TermsSection({
    required this.title,
    required this.paragraph,
    required this.bullets,
  });
}
