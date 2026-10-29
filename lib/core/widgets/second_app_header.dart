import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Secondary reusable gradient header widget.
///
/// Design Specs:
///   • Width: 360 (full screen width on design, responsive via double.infinity)
///   • Height: 133px visible + status bar (TOTAL = statusBarHeight + 133)
///   • Angle: 0 deg
///   • Opacity: 1
///
/// Layout (matches My Products header style):
///   • Dark gradient background (0xFF003A8A → 0xFF000F24)
///   • Back arrow and title sit side-by-side in a Row, vertically centered in
///     the visible area and aligned to the left
///
/// Difference from AppHeader:
///   • Total height is statusBarHeight + 133 (shorter than AppHeader's 192px)
///   • Arrow and title are in a Row (inline), not stacked in a Column
///
/// Used by: add product, my product, edit product, RFQ request, RFQ detail,
///          my order, order detail, order status, order updates, track status,
///          my wallet, my profile
///
/// Usage:
/// ```dart
/// // Simple
/// const SecondAppHeader(title: 'My Products')
///
/// // No back button
/// const SecondAppHeader(title: 'My Profile', showBackButton: false)
///
/// // Custom back handler
/// SecondAppHeader(title: 'Edit Product', onBackPressed: () { ... })
/// ```
class SecondAppHeader extends StatelessWidget {
  /// Title shown inline with the back arrow.
  final String title;

  /// Whether to show the back arrow (default: true).
  final bool showBackButton;

  /// Override the back-button behaviour. Defaults to [Navigator.pop].
  final VoidCallback? onBackPressed;

  /// Whether to vertically center the arrow and title in the header.
  /// Set to false to keep the content aligned near the bottom.
  final bool centerContentVertically;

  const SecondAppHeader({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.onBackPressed,
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
                    child: const SizedBox(
                      width: 24,
                      height: 24,
                      child: Icon(
                        Icons.arrow_back,
                        color: Color(0xFFEEEEEE),
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
