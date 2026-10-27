import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Reusable continue button with consistent styling across screens
/// Features an arrow icon and can be customized with different text
class AppContinueButton extends StatelessWidget {
  /// The text to display on the button
  final String text;
  
  /// Callback function when button is pressed
  final VoidCallback onPressed;
  
  /// Whether to show loading indicator
  final bool isLoading;
  
  /// Custom width (default: full width)
  final double? width;
  
  /// Custom height (default: 48)
  final double height;
  
  /// Whether to show the arrow icon (default: true)
  final bool showArrow;
  
  /// Custom background color (default: Color(0xFF003D82))
  final Color? backgroundColor;
  
  /// Custom text color (default: white)
  final Color? textColor;

  const AppContinueButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.width,
    this.height = 48,
    this.showArrow = true,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? const Color(0xFF003D82),
          foregroundColor: textColor ?? Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(text),
                  if (showArrow) ...[
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 18,
                      color: textColor ?? Colors.white,
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}
