import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Reusable gradient header widget.
///
/// Design Specs:
///   • Width: 360 (full screen width on design)
///   • Height: 192px (TOTAL including status bar)
///   • Angle: 0 deg
///   • Opacity: 1
///
/// Layout:
///   • Dark gradient background (0xFF003A8A → 0xFF000F24)
///   • Back arrow pinned to the top-left (hidden when [showBackButton] is false)
///   • Title text pinned to the bottom-left — always parallel / aligned with
///     the bottom edge, regardless of device status-bar height
///
/// Usage:
/// ```dart
/// // Simple — title at bottom, back arrow at top
/// const AppHeader(title: 'Company Details')
///
/// // No back button (e.g. root tab)
/// const AppHeader(title: 'Dashboard', showBackButton: false)
///
/// // Custom tap handler
/// AppHeader(title: 'Settings', onBackPressed: () { ... })
/// ```
class AppHeader extends StatelessWidget {
  /// Title shown at the bottom-left of the header.
  final String title;

  /// Whether to show the back arrow (default: true).
  final bool showBackButton;

  /// Override the back-button behaviour. Defaults to [Navigator.pop].
  final VoidCallback? onBackPressed;

  /// Visible height below the status bar.
  /// Note: Total header height is always 192px (including status bar).
  /// This parameter is deprecated and only kept for backward compatibility.
  @Deprecated('Total height is now fixed at 192px. This parameter has no effect.')
  final double visibleHeight;

  // ── Deprecated params kept for API compatibility ──────────
  // These no longer affect layout but won't break existing call sites.

  /// Ignored — kept for backward compatibility only.
  @Deprecated('No longer used. Title is always at the bottom.')
  final bool titleBelowBackButton;

  /// Ignored — kept for backward compatibility only.
  @Deprecated('Use visibleHeight instead.')
  final double height;

  /// Ignored — kept for backward compatibility only.
  @Deprecated('No longer used.')
  final double maxContentWidth;

  const AppHeader({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.onBackPressed,
    this.visibleHeight = 117,
    // deprecated — accepted but ignored
    // ignore: deprecated_member_use_from_same_package
    this.titleBelowBackButton = false,
    // ignore: deprecated_member_use_from_same_package
    this.height = 192,
    // ignore: deprecated_member_use_from_same_package
    this.maxContentWidth = 327,
  });

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    
    // Total height is always 192px (including status bar)
    const totalHeight = 192.0;

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
          left: 16,
          right: 16,
          top: statusBarHeight + 12, // top breathing room below status bar
          bottom: 14,                // bottom breathing room above screen edge
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Back arrow — padded from top ───────────────
            if (showBackButton)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: GestureDetector(
                  onTap: onBackPressed ?? () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Color(0xFFEEEEEE),
                    size: 24,
                  ),
                ),
              ),

            // ── Spacer pushes title to the bottom ──────────
            const Spacer(),

            // ── Title — padded from bottom ──────────────────
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFEEEEEE),
                  letterSpacing: -0.5,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
