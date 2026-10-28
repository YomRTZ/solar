import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Reusable header widget with gradient background, back button, and title
/// Used across multiple screens for consistent header styling
class AppHeader extends StatelessWidget {
  /// The title text to display in the header
  final String title;

  /// Whether to show the back button (default: true)
  final bool showBackButton;

  /// Whether to place the title directly below the back button
  final bool titleBelowBackButton;

  /// Custom action when back button is pressed
  /// If null, uses Navigator.pop(context)
  final VoidCallback? onBackPressed;

  /// Height of the header (default: 192)
  final double height;

  /// Maximum width for the content (default: 327)
  final double maxContentWidth;

  const AppHeader({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.titleBelowBackButton = false,
    this.onBackPressed,
    this.height = 192,
    this.maxContentWidth = 327,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final totalHeight = height + statusBarHeight;

    return Center(
      child: SizedBox(
        width: screenWidth,
        height: totalHeight,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF003A8A), Color(0xFF000F24)],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                // 16px below status bar — matches all custom gradient headers
                top: statusBarHeight + 16,
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showBackButton) ...[
                      GestureDetector(
                        onTap: onBackPressed ?? () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Color(0xFFEEEEEE),
                          size: 24,
                        ),
                      ),
                    ],
                    if (titleBelowBackButton && showBackButton)
                      const SizedBox(height: 16),
                    if (!titleBelowBackButton) const Spacer(),
                    Text(
                      title,
                      maxLines: 1,
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        height: 1.2,
                        letterSpacing: -0.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFEEEEEE),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
