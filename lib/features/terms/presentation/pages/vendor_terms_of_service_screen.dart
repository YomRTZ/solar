import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_app/core/widgets/app_header.dart';

class VendorTermsOfServiceScreen extends StatelessWidget {
  const VendorTermsOfServiceScreen({super.key});

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
            AppHeader(
              title: 'Terms of Service',
              onBackPressed: () => Navigator.maybePop(context),
            ),

            const Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20, 21, 20, 24),
                child: _TermsContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TermsContent extends StatelessWidget {
  const _TermsContent();

  static const String _loremLong =
      'Tellus at sit ante rutrum suspendisse pretium, vitae vel dignissim. '
      'Nunc, scelerisque adipiscing condimentum massa dignissim tortor leo '
      'lacus. Sapien felis ultrices fringilla nisi sit nibh. Etiam volutpat '
      'nisl ornare lorem mus at a, et pulvinar.';

  static const String _loremMid =
      'Fermentum erat nisl duis varius risus. Augue ac facilisi porta metus '
      'enim. Ullamcorper lacus praesent rhoncus, sapien rutrum nulla mattis '
      'vitae ultrices.';

  static const List<String> _bullets = [
    'Fermentum erat nisl duis varius risus.',
    'Augue ac facilisi porta metus enim.',
    'Ullamcorper lacus praesent rhoncus, sapien rutrum nulla mattis vitae ultrices.',
    'Nunc, scelerisque adipiscing condimentum massa dignissim tortor leo lacus.',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeading(number: '1.', title: 'Terms'),
        const SizedBox(height: 8),
        const _BodyText(_loremLong),
        const SizedBox(height: 22),

        const _SectionHeading(number: '2.', title: 'Use License'),
        const SizedBox(height: 8),
        const _BodyText(_loremMid),
        const SizedBox(height: 12),
        ..._bullets.map(
          (b) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _BulletItem(text: b),
          ),
        ),
        const SizedBox(height: 22),

        const _SectionHeading(number: '3.', title: 'Disclaimer'),
        const SizedBox(height: 8),
        const _BodyText(_loremLong),
        const SizedBox(height: 22),

        const _SectionHeading(number: '4.', title: 'Limitations'),
        const SizedBox(height: 8),
        const _BodyText(_loremMid),
        const SizedBox(height: 22),

        const _SectionHeading(number: '5.', title: 'Privacy Policy'),
        const SizedBox(height: 8),
        const _BodyText(_loremLong),
        const SizedBox(height: 22),

        const _SectionHeading(number: '6.', title: 'Governing Law'),
        const SizedBox(height: 8),
        const _BodyText(_loremMid),
      ],
    );
  }
}


class _SectionHeading extends StatelessWidget {
  final String number;
  final String title;
  const _SectionHeading({required this.number, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$number $title',
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF0A1F44),
        letterSpacing: -0.2,
      ),
    );
  }
}

class _BodyText extends StatelessWidget {
  final String text;
  const _BodyText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF4B5563),
        height: 1.65,
      ),
    );
  }
}

class _BulletItem extends StatelessWidget {
  final String text;
  const _BulletItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 7),
          child: Container(
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              color: Color(0xFF4B5563),
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF4B5563),
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}
