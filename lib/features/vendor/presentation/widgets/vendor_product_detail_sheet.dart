import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_app/core/widgets/app_bottom_sheet.dart';
import 'package:flutter_app/features/vendor/presentation/widgets/vendor_add_to_rfq_button.dart';
import 'package:flutter_app/features/vendor/presentation/widgets/vendor_price_badge.dart';
import 'package:flutter_app/features/catalog/domain/entities/catalog_product.dart';

// ───────────────────────────────────────────────────────────────────────────── Vendor Product
class VendorProductDetailSheet extends StatelessWidget {
  final CatalogProduct product;
  final int quantity;
  final int cartCount;

  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onAddToRFQ;
  final VoidCallback onAddToCompare;

  const VendorProductDetailSheet({
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
      handleTopMargin: 12,
      topTrailingAction: _CartBadge(count: cartCount),
      sheetWidth: null,
      sheetHeight: null,
      horizontalMargin: 0,
      includeSafeAreaBottom: false,
      child: VendorProductDetailSheet(
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
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(20, 43, 20, 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 1),
                      child: Image.asset(
                        'assets/solarimages/5dc175c533f86ed941b1004c6b373c14c68068d0.png',
                        width: 10,
                        height: 14.6875,
                        fit: BoxFit.fill,
                      ),
                    ),
                    const SizedBox(width: 1.31),
                    Padding(
                      padding: const EdgeInsets.only(top: 1),
                      child: Text(
                        product.brandName,
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1,
                          letterSpacing: 0,
                          color: const Color(0xFF008000),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // ── Product hero row ────────────────────────────
                _ProductHero(product: product),

                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 8.5),
                  child: _QuantityStepper(
                    quantity: quantity,
                    onDecrement: onDecrement,
                    onIncrement: onIncrement,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          // ── Spec table ──────────────────────────────────
          _SpecTable(product: product),

          const SizedBox(height: 15),

          // ── Action buttons ───────────────────────────────
          LayoutBuilder(
            builder: (context, constraints) {
              const gap = 10.0;
              const buttonWidths = 159.0 + 147.0;
              final totalWidth = constraints.maxWidth.clamp(
                0.0,
                buttonWidths + gap,
              );
              final buttonScale = totalWidth >= buttonWidths + gap
                  ? 1.0
                  : ((totalWidth - gap).clamp(0.0, buttonWidths)) /
                        buttonWidths;

              return Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: totalWidth,
                  child: Row(
                    children: [
                      _OutlineBtn(
                        label: 'Add to Compare',
                        onTap: onAddToCompare,
                        width: 159 * buttonScale,
                      ),
                      SizedBox(width: totalWidth > gap ? gap : 0),
                      VendorAddToRfqButton(
                        onPressed: onAddToRFQ,
                        buttonWidth: 147 * buttonScale,
                        buttonHeight: 41,
                        borderRadius: 10,
                        borderWidth: 1,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────── Sub-widgets

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
          height: 70,
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

        const SizedBox(width: 16),

        // Name + price + stock
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                maxLines: 2,
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

              const SizedBox(height: 8),

              // Price badge
              VendorPriceBadge(price: product.price),

              const SizedBox(height: 8),

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
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 1,
                      letterSpacing: 0,
                      color: product.inStock
                          ? const Color(0xFF008000)
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
          style: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1.32,
            letterSpacing: 0,
            color: const Color(0xFF333333),
          ),
        ),
        const SizedBox(width: 16),
        Container(
          width: 135,
          height: 30,
          decoration: BoxDecoration(
            color: const Color(0xFF003A8A),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0x1FFFFFFF), width: 1),
            boxShadow: const [
              BoxShadow(
                color: Color(0xFF375DFB),
                blurRadius: 0,
                spreadRadius: 1,
              ),
              BoxShadow(
                color: Color(0x7A253EA7),
                offset: Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x1FFFFFFF), Color(0x00FFFFFF)],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Center(
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
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1,
                        ),
                      ),
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
                ),
              ),
            ),
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
          final isAlternate = entry.key.isEven;
          final label = entry.value.$1;
          final value = entry.value.$2;

          return Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: isAlternate ? const Color(0xFFF7F7F8) : Colors.white,
              border: const Border(
                bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 110,
                  child: Text(
                    label,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 1.6,
                      letterSpacing: -0.24,
                      color: const Color(0xFF1D2939),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    value,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      height: 20 / 11,
                      color: const Color(0xFF1D2939),
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
  final double width;
  const _OutlineBtn({
    required this.label,
    required this.onTap,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: 41,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF003A8A), width: 2),
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
