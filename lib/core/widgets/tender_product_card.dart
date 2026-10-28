import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Reusable vertical product card used in the Tender "All Products" grid.
///
/// Two visual states driven by [quantity]:
///   - `0`  → shows a full-width "Add to RFQ" button
///   - `>0` → shows a quantity row: [🗑] [count] [+]
///
/// The card matches the design in the screenshot:
/// light-blue image background, white content area, price badge, action row.
///
/// Usage:
/// ```dart
/// TenderProductCard(
///   imagePath: 'assets/images/solar.png',
///   name: '100 X 100 Solar Panel Matched Premium',
///   price: 'Rs.10000',
///   quantity: qty,
///   onAdd: () { ... },
///   onIncrement: () { ... },
///   onDecrement: () { ... },
/// );
/// ```
class TenderProductCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String price;

  /// Current quantity in the RFQ cart (0 = not yet added).
  final int quantity;

  /// Fires when the "Add to RFQ" button is tapped (quantity == 0).
  final VoidCallback onAdd;

  /// Fires when + is tapped (quantity > 0).
  final VoidCallback onIncrement;

  /// Fires when 🗑/− is tapped (quantity > 0).
  final VoidCallback onDecrement;

  /// Tapped anywhere on the card (optional — e.g. open detail page).
  final VoidCallback? onTap;

  /// Whether [imagePath] is a network URL (default: false).
  final bool isNetworkImage;

  const TenderProductCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.price,
    required this.quantity,
    required this.onAdd,
    required this.onIncrement,
    required this.onDecrement,
    this.onTap,
    this.isNetworkImage = false,
  });

  // ── Shared button decoration ───────────────────────────────
  static const BoxDecoration _btnDecoration = BoxDecoration(
    color: Color(0xFF003A8A),
    borderRadius: BorderRadius.all(Radius.circular(8)),
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFD6E4F7), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Image area ─────────────────────────────────
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(9)),
                child: Container(
                  color: const Color(0xFFD6EAFF),
                  child: isNetworkImage
                      ? Image.network(imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, st) => _imgPlaceholder())
                      : Image.asset(imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, st) => _imgPlaceholder()),
                ),
              ),
            ),

            // ── Content area ───────────────────────────────
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(9, 8, 9, 9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product name
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1A1A),
                        height: 1.35,
                        letterSpacing: -0.1,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Price badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
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

                    const Spacer(),

                    // Action row
                    quantity == 0
                        ? _AddToRFQButton(
                            onTap: onAdd,
                            decoration: _btnDecoration,
                          )
                        : _QuantityRow(
                            quantity: quantity,
                            onDecrement: onDecrement,
                            onIncrement: onIncrement,
                            decoration: _btnDecoration,
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imgPlaceholder() => const Center(
        child: Icon(Icons.image_outlined, color: Color(0xFF90B4D4), size: 32),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets (private)
// ─────────────────────────────────────────────────────────────────────────────

class _AddToRFQButton extends StatelessWidget {
  final VoidCallback onTap;
  final BoxDecoration decoration;

  const _AddToRFQButton({required this.onTap, required this.decoration});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 28,
        decoration: decoration,
        child: Center(
          child: Text(
            'Add to RFQ',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: -0.1,
            ),
          ),
        ),
      ),
    );
  }
}

class _QuantityRow extends StatelessWidget {
  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final BoxDecoration decoration;

  const _QuantityRow({
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
    required this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      decoration: decoration,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onDecrement,
            child: const Icon(
              Icons.delete_outline_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
          Text(
            '$quantity',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          GestureDetector(
            onTap: onIncrement,
            child: const Icon(Icons.add_rounded, color: Colors.white, size: 16),
          ),
        ],
      ),
    );
  }
}
