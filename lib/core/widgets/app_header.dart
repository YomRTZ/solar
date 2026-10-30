import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

// Reusable gradient header widget.
class AppHeader extends StatelessWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  // ── Deprecated params kept for API compatibility ──────────
  @Deprecated('Total height is now fixed at 192px. This parameter has no effect.')
  final double visibleHeight;

  @Deprecated('No longer used. Title is always at the bottom.')
  final bool titleBelowBackButton;

  @Deprecated('Use visibleHeight instead.')
  final double height;

  @Deprecated('No longer used.')
  final double maxContentWidth;

  const AppHeader({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.onBackPressed,
    this.visibleHeight = 117,
    // ignore: deprecated_member_use_from_same_package
    this.titleBelowBackButton = false,
    // ignore: deprecated_member_use_from_same_package
    this.height = 192,
    // ignore: deprecated_member_use_from_same_package
    this.maxContentWidth = 327,
  });

  @override
  Widget build(BuildContext context) {
    const totalHeight = 192.0;

    return SizedBox(
      width: double.infinity,
      height: totalHeight,
      child: Stack(
        children: [
          // ── Gradient background ───────────────────────────
          Positioned.fill(
            child: const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF003A8A), Color(0xFF000F24)],
                ),
              ),
            ),
          ),

          // ── Back arrow ────────────────────────────────────
          // left:24, right:312, top:68, bottom:100
          if (showBackButton)
            Positioned(
              top: 68,
              left: 24,
              right: 312,
              bottom: 100,
              child: GestureDetector(
                onTap: onBackPressed ?? () => Navigator.pop(context),
                child: SvgPicture.asset(
                  'assets/icons/arrow-narrow-left.svg',
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                ),
              ),
            ),

          // ── Title ─────────────────────────────────────────
          // left:24, right:9, top:116, bottom:34
          Positioned(
            top: 116,
            left: 24,
            right: 9,
            bottom: 34,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                  letterSpacing: 32 * -0.02,
                  color: const Color(0xFFEEEEEE),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
