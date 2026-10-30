import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../app/routing/app_routes.dart';
import '../../app/routing/route_data.dart';
import '../../core/widgets/second_app_header.dart';
import '../../core/widgets/tender_product_card.dart';
import '../../data/advtender_data.dart';
import '../../models/advtender_supplier.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AdvTender — Supplier Details Screen
//
// Layout:
//  • Dark-gradient header with back arrow + "Supplier Details" + cart badge
//  • Supplier info card (avatar, name, verified badge)
//  • Rating + Orders stats row
//  • "About Supplier" section
//  • "Main Products" heading + 2-col TenderProductCard grid
// ─────────────────────────────────────────────────────────────────────────────
class AdvTenderSupplierDetailsScreen extends StatefulWidget {
  final AdvTenderSupplier? supplier;

  const AdvTenderSupplierDetailsScreen({super.key, this.supplier});

  @override
  State<AdvTenderSupplierDetailsScreen> createState() =>
      _AdvTenderSupplierDetailsScreenState();
}

class _AdvTenderSupplierDetailsScreenState
    extends State<AdvTenderSupplierDetailsScreen> {
  // RFQ cart: productId → quantity
  final Map<String, int> _rfqCart = {};

  int get _cartCount => _rfqCart.values.fold(0, (sum, qty) => sum + qty);

  late final AdvTenderSupplier _supplier;

  @override
  void initState() {
    super.initState();
    _supplier = widget.supplier ?? AdvTenderData.demoSupplier;
  }

  void _add(String id) =>
      setState(() => _rfqCart[id] = (_rfqCart[id] ?? 0) + 1);

  void _increment(String id) =>
      setState(() => _rfqCart[id] = (_rfqCart[id] ?? 0) + 1);

  void _decrement(String id) {
    setState(() {
      final current = _rfqCart[id] ?? 0;
      if (current <= 1) {
        _rfqCart.remove(id);
      } else {
        _rfqCart[id] = current - 1;
      }
    });
  }

  void _goToCart() {
    final cartItems = _supplier.mainProducts
        .where((p) => (_rfqCart[p.id] ?? 0) > 0)
        .toList();

    context.push(
      AppRoutes.advTenderCart,
      extra: AdvTenderCartRouteData(
        cartItems: cartItems,
        initialQuantities: Map.from(_rfqCart),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F4F7),
        body: Column(
          children: [
            SecondAppHeader(
              title: 'Supplier Details',
              trailing: _buildCartAction(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Supplier info card ────────────────────
                    _SupplierInfoCard(supplier: _supplier),
                    const SizedBox(height: 16),

                    // ── Stats row ─────────────────────────────
                    _StatsRow(
                      rating: _supplier.rating,
                      totalOrders: _supplier.totalOrders,
                    ),
                    const SizedBox(height: 16),

                    // ── About ─────────────────────────────────
                    _SectionTitle(title: 'About Supplier'),
                    const SizedBox(height: 8),
                    Text(
                      _supplier.aboutText,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF6C7278),
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Main Products heading ─────────────────
                    _SectionTitle(title: 'Main Products'),
                    const SizedBox(height: 12),

                    // ── 2-col product grid ────────────────────
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 12,
                            childAspectRatio: 156 / 217,
                          ),
                      itemCount: _supplier.mainProducts.length,
                      itemBuilder: (context, i) {
                        final product = _supplier.mainProducts[i];
                        final qty = _rfqCart[product.id] ?? 0;
                        return TenderProductCard(
                          imagePath: product.imagePath,
                          name: product.name,
                          price: product.price,
                          quantity: qty,
                          onAdd: () => _add(product.id),
                          onIncrement: () => _increment(product.id),
                          onDecrement: () => _decrement(product.id),
                        );
                      },
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

  Widget _buildCartAction() {
    return GestureDetector(
      onTap: _cartCount > 0 ? _goToCart : null,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
              size: 22,
            ),
          ),
          if (_cartCount > 0)
            Positioned(
              top: -6,
              right: -6,
              child: Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF3B30),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    _cartCount > 99 ? '99+' : '$_cartCount',
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Supplier info card
// ─────────────────────────────────────────────────────────────────────────────
class _SupplierInfoCard extends StatelessWidget {
  final AdvTenderSupplier supplier;
  const _SupplierInfoCard({required this.supplier});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F0FE),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(6),
            child: Image.asset(
              supplier.iconPath,
              fit: BoxFit.contain,
              errorBuilder: (ctx, e, s) => const Icon(
                Icons.business_rounded,
                color: Color(0xFF003A8A),
                size: 28,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Name + badge
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  supplier.name,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1FAE5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    supplier.badge,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF065F46),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Stats row
// ─────────────────────────────────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  final double rating;
  final int totalOrders;
  const _StatsRow({required this.rating, required this.totalOrders});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            value: rating.toStringAsFixed(1),
            label: 'Rating',
            valueColor: const Color(0xFF003A8A),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            value: '$totalOrders+',
            label: 'Orders',
            valueColor: const Color(0xFF003A8A),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;
  const _StatCard({
    required this.value,
    required this.label,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: valueColor,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF6C7278),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section title
// ─────────────────────────────────────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF1A1A1A),
        letterSpacing: -0.2,
      ),
    );
  }
}
