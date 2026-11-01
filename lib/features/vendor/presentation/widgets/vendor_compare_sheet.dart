import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_app/core/widgets/app_bottom_sheet.dart';
import 'package:flutter_app/features/vendor/presentation/widgets/vendor_add_to_rfq_button.dart';
import 'package:flutter_app/features/catalog/domain/entities/catalog_product.dart';

// ───────────────────────────────────────────────────────────────────────────── Vendor Compare
class VendorCompareSheet extends StatelessWidget {
  // Products currently in the compare list (1 to [maxSlots]).
  final List<CatalogProduct> products;

  // Current RFQ cart quantities — used to show "Add to RFQ" state.
  final Map<String, int> rfqCartCounts;

  // Total items in the RFQ cart (for the header badge).
  final int cartCount;

  // Called when "Add to RFQ" is tapped for a product.
  final void Function(CatalogProduct product) onAddToRFQ;

  // Maximum number of comparison slots (default 2).
  final int maxSlots;

  const VendorCompareSheet({
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
      child: VendorCompareSheet(
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
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                  color: const Color(0xFF003A8A),
                  letterSpacing: -0.36,
                ),
              ),
              const Spacer(),
              _CartBadge(count: cartCount),
            ],
          ),

          const SizedBox(height: 16),

          // ── Product image slots ─────────────────────────
          _ImageSlotRow(products: products, maxSlots: maxSlots),

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

// ───────────────────────────────────────────────────────────────────────────── Image slot row
class _ImageSlotRow extends StatelessWidget {
  final List<CatalogProduct> products;
  final int maxSlots;

  const _ImageSlotRow({required this.products, required this.maxSlots});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(width: 120),
          const SizedBox(width: 8),
          ...List.generate(maxSlots, (i) {
            final hasProduct = i < products.length;
            return Padding(
              padding: EdgeInsets.only(right: i < maxSlots - 1 ? 8 : 0),
              child: SizedBox(
                width: 120,
                child: hasProduct
                    ? _ProductImageTile(product: products[i])
                    : _AddProductSlot(),
              ),
            );
          }),
        ],
      ),
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
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
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
            child: Image.asset(
              'assets/icons/5ceff9d5d9cae078a369c65ead35be73405d7dcd.png',
              width: 18,
              height: 18,
              fit: BoxFit.contain,
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

// ───────────────────────────────────────────────────────────────────────────── Comparison table
class _CompareTable extends StatelessWidget {
  final List<CatalogProduct> products;
  final int maxSlots;

  const _CompareTable({required this.products, required this.maxSlots});

  @override
  Widget build(BuildContext context) {
    // Spec rows: label + extractor function
    final specs = <(String, String Function(CatalogProduct))>[
      (
        'Name',
        (p) => p.name.length > 20 ? '${p.name.substring(0, 18)}…' : p.name,
      ),
      ('Price', (_) => '15,800'),
      ('Power', (_) => '12W'),
      ('Warranty', (_) => '12-08-32'),
      ('Stock', (p) => p.inStock ? 'In Stock' : 'Out of Stock'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          children: specs.asMap().entries.map((entry) {
            final label = entry.value.$1;
            final extractor = entry.value.$2;
            final isStock = label == 'Stock';

            return SizedBox(
              height: 33.2,
              child: Row(
                children: [
                  Container(
                    width: 120,
                    height: 33.2,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF7F7F8),
                      border: Border(
                        bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
                      ),
                    ),
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        height: 1.6,
                        letterSpacing: -0.24,
                        color: const Color(0xFF1D2939),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ...List.generate(maxSlots, (i) {
                    final hasProduct = i < products.length;
                    final value = hasProduct ? extractor(products[i]) : '—';
                    final isInStock =
                        hasProduct && isStock && products[i].inStock;

                    return Padding(
                      padding: EdgeInsets.only(right: i < maxSlots - 1 ? 8 : 0),
                      child: Container(
                        width: 120,
                        height: 33.2,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color(0xFFE5E7EB),
                              width: 1,
                            ),
                          ),
                        ),
                        child: isStock && hasProduct
                            ? _StockChip(inStock: isInStock)
                            : Text(
                                value,
                                textAlign: TextAlign.center,
                                style: label == 'Name'
                                    ? GoogleFonts.plusJakartaSans(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        height: 1.6,
                                        letterSpacing: -0.2,
                                        color: const Color(0xFF1D2939),
                                      )
                                    : GoogleFonts.inter(
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
      ),
    );
  }
}

class _StockChip extends StatelessWidget {
  final bool inStock;
  const _StockChip({required this.inStock});

  @override
  Widget build(BuildContext context) {
    return Text(
      inStock ? 'In Stock' : 'Out of Stock',
      style: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: inStock ? const Color(0xFF008000) : const Color(0xFF9F1239),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────── "Add to RFQ"
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(width: 120),
          const SizedBox(width: 8),
          ...List.generate(maxSlots, (i) {
            final hasProduct = i < products.length;
            return Padding(
              padding: EdgeInsets.only(right: i < maxSlots - 1 ? 8 : 0),
              child: SizedBox(
                width: 120,
                child: hasProduct
                    ? VendorAddToRfqButton(
                        onPressed: () => onAddToRFQ(products[i]),
                      )
                    : const SizedBox.shrink(),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────── Cart badge (reused
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
