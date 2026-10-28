import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/widgets/app_bottom_sheet.dart';
import '../../models/catalog_product.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Tender Compare Sheet
//
// Bottom sheet that shows a side-by-side comparison table.
// Up to [maxSlots] products can be compared (default 2).
// The last slot is an "Add Product" placeholder if not full.
//
// Usage:
//   TenderCompareSheet.show(
//     context: context,
//     products: compareList,        // List<CatalogProduct>, 1–maxSlots items
//     rfqCartCounts: rfqCart,       // Map<String, int>
//     cartCount: totalCartCount,
//     onAddToRFQ: (product) { ... },
//   );
// ─────────────────────────────────────────────────────────────────────────────
class TenderCompareSheet extends StatelessWidget {
  /// Products currently in the compare list (1 to [maxSlots]).
  final List<CatalogProduct> products;

  /// Current RFQ cart quantities — used to show "Add to RFQ" state.
  final Map<String, int> rfqCartCounts;

  /// Total items in the RFQ cart (for the header badge).
  final int cartCount;

  /// Called when "Add to RFQ" is tapped for a product.
  final void Function(CatalogProduct product) onAddToRFQ;

  /// Maximum number of comparison slots (default 2).
  final int maxSlots;

  const TenderCompareSheet({
    super.key,
    required this.products,
    required this.rfqCartCounts,
    required this.cartCount,
    required this.onAddToRFQ,
    this.maxSlots = 2,
  });

  static Future<void> show({
    required BuildContext context,
    required List<CatalogProduct> products,
    required Map<String, int> rfqCartCounts,
    required int cartCount,
    required void Function(CatalogProduct) onAddToRFQ,
    int maxSlots = 2,
  }) {
    return AppBottomSheet.show(
      context: context,
      horizontalPadding: 0,
      bottomPadding: 0,
      child: TenderCompareSheet(
        products: products,
        rfqCartCounts: rfqCartCounts,
        cartCount: cartCount,
        onAddToRFQ: onAddToRFQ,
        maxSlots: maxSlots,
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
          // ── Header: title + cart badge ──────────────────
          Row(
            children: [
              Text(
                'Compare Products',
                style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                  letterSpacing: -0.3,
                ),
              ),
              const Spacer(),
              _CartBadge(count: cartCount),
            ],
          ),

          const SizedBox(height: 16),

          // ── Product image slots ─────────────────────────
          _ImageSlotRow(
            products: products,
            maxSlots: maxSlots,
          ),

          const SizedBox(height: 16),

          // ── Comparison table ────────────────────────────
          _CompareTable(products: products, maxSlots: maxSlots),

          const SizedBox(height: 20),

          // ── "Add to RFQ" buttons row ────────────────────
          _AddToRFQRow(
            products: products,
            maxSlots: maxSlots,
            onAddToRFQ: onAddToRFQ,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Image slot row
// ─────────────────────────────────────────────────────────────────────────────
class _ImageSlotRow extends StatelessWidget {
  final List<CatalogProduct> products;
  final int maxSlots;

  const _ImageSlotRow({required this.products, required this.maxSlots});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Empty first column (aligns with the label column in the table)
        const SizedBox(width: 80),
        const SizedBox(width: 12),

        // One slot per position
        ...List.generate(maxSlots, (i) {
          final hasProduct = i < products.length;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i < maxSlots - 1 ? 12 : 0),
              child: hasProduct
                  ? _ProductImageTile(product: products[i])
                  : _AddProductSlot(),
            ),
          );
        }),
      ],
    );
  }
}

class _ProductImageTile extends StatelessWidget {
  final CatalogProduct product;
  const _ProductImageTile({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
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
          size: 28,
        ),
      ),
    );
  }
}

class _AddProductSlot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F0FE),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.add_rounded,
              color: Color(0xFF003A8A),
              size: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Add Product',
            style: GoogleFonts.inter(
              fontSize: 9,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6C7278),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Comparison table
// ─────────────────────────────────────────────────────────────────────────────
class _CompareTable extends StatelessWidget {
  final List<CatalogProduct> products;
  final int maxSlots;

  const _CompareTable({required this.products, required this.maxSlots});

  @override
  Widget build(BuildContext context) {
    // Spec rows: label + extractor function
    final specs = <(String, String Function(CatalogProduct))>[
      ('Name', (p) => p.name.length > 20 ? '${p.name.substring(0, 18)}…' : p.name),
      ('Price', (p) => p.price),
      ('Power', (p) => p.power),
      ('Warranty', (p) => p.warranty),
      ('Stock', (p) => p.inStock ? 'In Stock' : 'Out of Stock'),
    ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: specs.asMap().entries.map((entry) {
          final isLast = entry.key == specs.length - 1;
          final label = entry.value.$1;
          final extractor = entry.value.$2;
          final isStock = label == 'Stock';

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              border: isLast
                  ? null
                  : const Border(
                      bottom: BorderSide(color: Color(0xFFE5E7EB))),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Label column
                SizedBox(
                  width: 68,
                  child: Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Value columns — one per slot
                ...List.generate(maxSlots, (i) {
                  final hasProduct = i < products.length;
                  final value =
                      hasProduct ? extractor(products[i]) : '—';
                  final isInStock =
                      hasProduct && isStock && products[i].inStock;

                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: i == 0 ? 0 : 8),
                      child: isStock && hasProduct
                          ? _StockChip(inStock: isInStock)
                          : Text(
                              value,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF4B5563),
                              ),
                            ),
                    ),
                  );
                }),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _StockChip extends StatelessWidget {
  final bool inStock;
  const _StockChip({required this.inStock});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: inStock
            ? const Color(0xFFD1FAE5)
            : const Color(0xFFFFE4E6),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        inStock ? 'In Stock' : 'Out of Stock',
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: inStock
              ? const Color(0xFF065F46)
              : const Color(0xFF9F1239),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// "Add to RFQ" button row
// ─────────────────────────────────────────────────────────────────────────────
class _AddToRFQRow extends StatelessWidget {
  final List<CatalogProduct> products;
  final int maxSlots;
  final void Function(CatalogProduct) onAddToRFQ;

  const _AddToRFQRow({
    required this.products,
    required this.maxSlots,
    required this.onAddToRFQ,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Spacer matching the label column width in the table
        const SizedBox(width: 80),
        const SizedBox(width: 12),

        ...List.generate(maxSlots, (i) {
          final hasProduct = i < products.length;
          return Expanded(
            child: Padding(
              padding:
                  EdgeInsets.only(right: i < maxSlots - 1 ? 12 : 0),
              child: hasProduct
                  ? _RFQButton(
                      onTap: () => onAddToRFQ(products[i]),
                    )
                  : const SizedBox.shrink(),
            ),
          );
        }),
      ],
    );
  }
}

class _RFQButton extends StatelessWidget {
  final VoidCallback onTap;
  const _RFQButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF003A8A),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            'Add to RFQ',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Cart badge (reused from detail sheet to avoid cross-file private dep)
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
