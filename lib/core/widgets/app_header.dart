import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Reusable header widget with gradient background, back button, and title
/// Used across multiple screens for consistent header styling
class AppHeader extends StatelessWidget {
  /// The title text to display in the header
  final String title;
  
  /// Whether to show the back button (default: true)
  final bool showBackButton;
  
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
    this.onBackPressed,
    this.height = 192,
    this.maxContentWidth = 327,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final headerWidth = screenWidth < maxContentWidth ? screenWidth : maxContentWidth;
    // Total height = status bar + visible 192px content
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
                // 68px below status bar top
                top: statusBarHeight + 68,
                left: (screenWidth - headerWidth) / 2,
                width: headerWidth,
                height: 90,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showBackButton)
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Color(0xFFEEEEEE),
                            size: 24,
                          ),
                          onPressed: onBackPressed ?? () => Navigator.pop(context),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ),
                    SizedBox(height: showBackButton ? 24 : 0),
                    SizedBox(
                      width: headerWidth,
                      height: 42,
                      child: Text(
                        title,
                        maxLines: 1,
                        style: GoogleFonts.inter(
                          fontSize: 32,
                          height: 1.3,
                          letterSpacing: -0.64,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFEEEEEE),
                        ),
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
