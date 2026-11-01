import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_app/features/vendor/presentation/widgets/vendor_add_to_rfq_button.dart';
import 'package:flutter_app/features/vendor/presentation/widgets/vendor_price_badge.dart';

// Reusable vertical product card used in the Vendor "All Products" grid
class VendorProductCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String price;

  // Current quantity in the RFQ cart (0 = not yet added).
  final int quantity;

  // Fires when the "Add to RFQ" button is tapped (quantity == 0).
  final VoidCallback onAdd;

  // Fires when + is tapped (quantity > 0).
  final VoidCallback onIncrement;

  // Fires when 🗑/− is tapped (quantity > 0).
  final VoidCallback onDecrement;

  // Tapped anywhere on the card (optional — e.g. open detail page).
  final VoidCallback? onTap;

  // Whether [imagePath] is a network URL (default: false).
  final bool isNetworkImage;

  // Show the small brand mark over the product image.
  final bool showBrandMark;

  const VendorProductCard({
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
    this.showBrandMark = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFC0C5C8), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Image area ─────────────────────────────────
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(6.5),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      color: const Color(0xFFD6EAFF),
                      child: isNetworkImage
                          ? Image.network(
                              imagePath,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, st) => _imgPlaceholder(),
                            )
                          : Image.asset(
                              imagePath,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, st) => _imgPlaceholder(),
                            ),
                    ),
                    if (showBrandMark)
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Image.asset(
                          'assets/solarimages/5dc175c533f86ed941b1004c6b373c14c68068d0.png',
                          width: 10,
                          height: 14.6875,
                          fit: BoxFit.fill,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // ── Content area ───────────────────────────────
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product name
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.roboto(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                        color: const Color(0xFF23201C),
                        height: 1,
                        letterSpacing: 0,
                      ),
                    ),

                    const SizedBox(height: 6),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: VendorPriceBadge(price: price),
                      ),
                    ),

                    // Action row
                    quantity == 0
                        ? _AddToRFQButton(onTap: onAdd)
                        : _QuantityRow(
                            quantity: quantity,
                            onDecrement: onDecrement,
                            onIncrement: onIncrement,
                            decoration: const BoxDecoration(
                              color: Color(0xFF003A8A),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
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

// ───────────────────────────────────────────────────────────────────────────── Sub-widgets

class _AddToRFQButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddToRFQButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return VendorAddToRfqButton(onPressed: onTap);
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
            child: SvgPicture.asset(
              'assets/icons/Delete.svg',
              width: 24,
              height: 24,
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
            child: SvgPicture.asset(
              'assets/icons/Add.svg',
              width: 24,
              height: 24,
            ),
          ),
        ],
      ),
    );
  }
}
