import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_app/features/vendor/presentation/widgets/vendor_price_badge.dart';

/// Reusable horizontal RFQ cart item card used in the vendor cart screen.
///
/// Shows: thumbnail | name + subtitle + price badge | qty stepper [🗑 count +]
///
/// Usage:
/// ```dart
/// VendorRfqCartCard(
///   imagePath: 'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
///   name: 'Solar Trade',
///   subtitle: 'By SunTech Sol.',
///   price: 'Rs.10000+',
///   quantity: qty,
///   onDecrement: () { ... },
///   onIncrement: () { ... },
/// );
/// ```
class VendorRfqCartCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String subtitle;
  final String price;
  final int quantity;

  /// Called when the delete / minus icon is tapped.
  final VoidCallback onDecrement;

  /// Called when the + icon is tapped.
  final VoidCallback onIncrement;

  /// Optional tap on the whole card.
  final VoidCallback? onTap;

  /// Whether [imagePath] is a network URL (default: false).
  final bool isNetworkImage;

  const VendorRfqCartCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.subtitle,
    required this.price,
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
    this.onTap,
    this.isNetworkImage = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // ── Thumbnail ──────────────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 72,
                height: 72,
                color: const Color(0xFFD6EAFF),
                child: isNetworkImage
                    ? Image.network(
                        imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, e, s) => _placeholder(),
                      )
                    : Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, e, s) => _placeholder(),
                      ),
              ),
            ),

            const SizedBox(width: 12),

            // ── Info ───────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      color: const Color(0xFF23201C),
                      letterSpacing: 0,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF6C7278),
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Price badge
                  VendorPriceBadge(price: price),
                ],
              ),
            ),

            const SizedBox(width: 10),

            // ── Qty stepper ───────────────────────────────
            _QtyStepper(
              quantity: quantity,
              onDecrement: onDecrement,
              onIncrement: onIncrement,
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() => const Center(
    child: Icon(Icons.image_outlined, color: Color(0xFF90B4D4), size: 28),
  );
}

// ── Quantity stepper [🗑 count +] ──────────────────────────────
class _QtyStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _QtyStepper({
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      decoration: BoxDecoration(
        color: const Color(0xFF003A8A),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onDecrement,
            child: const Icon(
              Icons.delete_outline_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '$quantity',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onIncrement,
            child: const Icon(Icons.add_rounded, color: Colors.white, size: 16),
          ),
        ],
      ),
    );
  }
}
