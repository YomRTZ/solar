import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Reusable horizontal RFQ cart item card used in the advtender cart screen.
///
/// Shows: thumbnail | name + subtitle + price badge | qty stepper [🗑 count +]
///
/// Usage:
/// ```dart
/// AdvTenderRfqCartCard(
///   imagePath: 'assets/...',
///   name: 'Solar Trade',
///   subtitle: 'By SunTech Sol.',
///   price: 'Rs.10000+',
///   quantity: qty,
///   onDecrement: () { ... },
///   onIncrement: () { ... },
/// );
/// ```
class AdvTenderRfqCartCard extends StatelessWidget {
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

  const AdvTenderRfqCartCard({
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
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A1A),
                      letterSpacing: -0.2,
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF003A8A).withValues(alpha: 0.09),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      price,
                      style: GoogleFonts.roboto(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF003A8A),
                      ),
                    ),
                  ),
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
        child: Icon(
          Icons.image_outlined,
          color: Color(0xFF90B4D4),
          size: 28,
        ),
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
            child: const Icon(
              Icons.add_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}
