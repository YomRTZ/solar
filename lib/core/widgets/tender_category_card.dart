import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Reusable square category card used in the Tender screens.
///
/// Shows a white rounded tile with a light-blue icon container on top
/// and a label below — matching the "All Categories" grid design.
///
/// Usage:
/// ```dart
/// TenderCategoryCard(
///   iconPath: 'assets/icons/image_1380.png',
///   label: 'Solar Panels',
///   onTap: () { ... },
/// );
/// ```
class TenderCategoryCard extends StatelessWidget {
  /// Asset path for the category icon image.
  final String iconPath;

  /// Label shown below the icon.
  final String label;

  /// Called when the card is tapped.
  final VoidCallback? onTap;

  /// Whether the icon image is from the network (default: false).
  final bool isNetworkImage;

  /// Size of the icon container (default: 56).
  final double iconContainerSize;

  /// Total card width (default: unconstrained — fills parent).
  final double? width;

  const TenderCategoryCard({
    super.key,
    required this.iconPath,
    required this.label,
    this.onTap,
    this.isNetworkImage = false,
    this.iconContainerSize = 56,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Icon container ───────────────────────────────
            Container(
              width: iconContainerSize,
              height: iconContainerSize,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F3FF),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(10),
              child: isNetworkImage
                  ? Image.network(
                      iconPath,
                      fit: BoxFit.contain,
                      errorBuilder: (ctx, err, st) => _placeholder(),
                    )
                  : Image.asset(
                      iconPath,
                      fit: BoxFit.contain,
                      errorBuilder: (ctx, err, st) => _placeholder(),
                    ),
            ),

            const SizedBox(height: 10),

            // ── Label ────────────────────────────────────────
            Text(
              label,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1A1A1A),
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() => const Icon(
        Icons.category_outlined,
        color: Color(0xFF003A8A),
        size: 28,
      );
}
