import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

// Secondary reusable gradient header widget. Design Specs:
class SecondAppHeader extends StatelessWidget {
  // Title shown inline with the back arrow.
  final String title;

  // Optional secondary line shown beneath the title.
  final String? subtitle;

  // Whether to show the back arrow (default: true).
  final bool showBackButton;

  // Override the back-button behaviour. Defaults to [Navigator.pop].
  final VoidCallback? onBackPressed;

  // Optional action displayed after the title.
  final Widget? trailing;

  // Whether to vertically center the arrow and title in the header
  final bool centerContentVertically;

  const SecondAppHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showBackButton = true,
    this.onBackPressed,
    this.trailing,
    this.centerContentVertically = true,
  });

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    // Design spec: 133px visible area + full status bar height
    const visibleHeight = 133.0;
    final totalHeight = statusBarHeight + visibleHeight;

    return Container(
      width: double.infinity,
      height: totalHeight,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF003A8A), Color(0xFF000F24)],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: showBackButton ? 19 : 16,
          right: 16,
          top: statusBarHeight + 24, // breathing room below status bar
          bottom: 16, // breathing room at bottom
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: centerContentVertically
              ? MainAxisAlignment.center
              : MainAxisAlignment.end,
          children: [
            // ── Back arrow + Title in a Row ─────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (showBackButton) ...[
                  GestureDetector(
                    onTap: onBackPressed ?? () => Navigator.pop(context),
                    child: SvgPicture.asset(
                      'assets/icons/arrow-narrow-left.svg',
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFEEEEEE),
                          letterSpacing: -0.4,
                          height: 1.3,
                        ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xB3FFFFFF),
                          ),
                        ),
                    ],
                  ),
                ),
                if (trailing != null) ...[const SizedBox(width: 8), trailing!],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
