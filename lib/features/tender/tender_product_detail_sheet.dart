import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/widgets/app_bottom_sheet.dart';
import '../../models/catalog_product.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Tender Product Detail Sheet
//
// Bottom sheet shown when a product card is tapped.
// Contains:
//   • Brand label + product name + image + price badge + stock status
//   • Quantity stepper (delete | count | +)
//   • Spec rows: Model Number, Category, Warranty, Dispatch Dist.
//   • Two action buttons: "Add to Compare"  |  "Add to RFQ"
//
// Usage via convenience launcher:
//   TenderProductDetailSheet.show(
//     context: context,
//     product: product,
//     quantity: qty,
//     cartCount: totalInCart,
//     onIncrement: () { ... },
//     onDecrement: () { ... },
//     onAddToRFQ: () { ... },
//     onAddToCompare: () { ... },
//   );
// ─────────────────────────────────────────────────────────────────────────────
class TenderProductDetailSheet extends StatelessWidget {
  final CatalogProduct product;
  final int quantity;
  final int cartCount;

  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onAddToRFQ;
  final VoidCallback onAddToCompare;

  const TenderProductDetailSheet({
    super.key,
    required this.product,
    required this.quantity,
    required this.cartCount,
    required this.onIncrement,
    required this.onDecrement,
    required this.onAddToRFQ,
    required this.onAddToCompare,
  });

  static Future<void> show({
    required BuildContext context,
    required CatalogProduct product,
    required int quantity,
    required int cartCount,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
    required VoidCallback onAddToRFQ,
    required VoidCallback onAddToCompare,
  }) {
    return AppBottomSheet.show(
      context: context,
      horizontalPadding: 0,
      bottomPadding: 0,
      child: TenderProductDetailSheet(
        product: product,
        quantity: quantity,
        cartCount: cartCount,
        onIncrement: onIncrement,
        onDecrement: onDecrement,
        onAddToRFQ: onAddToRFQ,
        onAddToCompare: onAddToCompare,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final safeBottom = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, safeBottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Cart badge row ──────────────────────────────
          Align(
            alignment: Alignment.centerRight,
            child: _CartBadge(count: cartCount),
          ),

          const SizedBox(height: 8),

          // ── Product hero row ────────────────────────────
          _ProductHero(product: product),

          const SizedBox(height: 16),

          // ── Quantity stepper ────────────────────────────
          _QuantityStepper(
            quantity: quantity,
            onDecrement: onDecrement,
            onIncrement: onIncrement,
          ),

          const SizedBox(height: 16),

          // ── Spec table ──────────────────────────────────
          _SpecTable(product: product),

          const SizedBox(height: 20),

          // ── Action buttons ──────────────────────────────
          Row(
            children: [
              Expanded(
                child: _OutlineBtn(
                  label: 'Add to Compare',
                  onTap: onAddToCompare,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _FilledBtn(
                  label: 'Add to RFQ',
                  onTap: onAddToRFQ,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _CartBadge extends StatelessWidget {
  final int count;
  const _CartBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFFF2F4F7),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.shopping_cart_outlined,
            color: Color(0xFF003A8A),
            size: 18,
          ),
        ),
        if (count > 0)
          Positioned(
            top: -5,
            right: -5,
            child: Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: Color(0xFFFF3B30),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  count > 9 ? '9+' : '$count',
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ProductHero extends StatelessWidget {
  final CatalogProduct product;
  const _ProductHero({required this.product});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Thumbnail
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFFD6EAFF),
            borderRadius: BorderRadius.circular(10),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            product.imagePath,
            fit: BoxFit.cover,
            errorBuilder: (ctx, err, st) => const Icon(
              Icons.image_outlined,
              color: Color(0xFF90B4D4),
              size: 32,
            ),
          ),
        ),

        const SizedBox(width: 14),

        // Name + price + stock
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Brand chip
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF27AE60),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    product.brandName,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF6C7278),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 4),

              Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                  letterSpacing: -0.2,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 8),

              // Price badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF003A8A).withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  product.price,
                  style: GoogleFonts.roboto(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF003A8A),
                  ),
                ),
              ),

              const SizedBox(height: 6),

              // Stock status
              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: product.inStock
                          ? const Color(0xFF27AE60)
                          : const Color(0xFFE74C3C),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    product.inStock ? 'In Stock' : 'Out of Stock',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: product.inStock
                          ? const Color(0xFF27AE60)
                          : const Color(0xFFE74C3C),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _QuantityStepper({
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Quantity',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        const Spacer(),
        // Stepper row: [🗑] [count] [+]
        Container(
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF003A8A),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: onDecrement,
                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '$quantity',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: onIncrement,
                child: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SpecTable extends StatelessWidget {
  final CatalogProduct product;
  const _SpecTable({required this.product});

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('Model Number', product.modelNumber),
      ('Category', product.category),
      ('Warranty', product.warranty),
      ('Dispatch Dist.', product.dispatchDist),
    ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: rows.asMap().entries.map((entry) {
          final isLast = entry.key == rows.length - 1;
          final label = entry.value.$1;
          final value = entry.value.$2;

          return Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              border: isLast
                  ? null
                  : const Border(
                      bottom:
                          BorderSide(color: Color(0xFFE5E7EB), width: 1)),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 110,
                  child: Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF6C7278),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    value,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _OutlineBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _OutlineBtn({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFF003A8A), width: 1.5),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF003A8A),
            ),
          ),
        ),
      ),
    );
  }
}

class _FilledBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _FilledBtn({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFF003A8A),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
