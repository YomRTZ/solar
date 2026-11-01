import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:flutter_app/app/routing/route_data.dart';
import 'package:flutter_app/core/widgets/second_app_header.dart';
import 'package:flutter_app/features/vendor/presentation/widgets/vendor_product_card.dart';
import 'package:flutter_app/features/supplier/data/datasources/supplier_data.dart';
import 'package:flutter_app/features/supplier/domain/entities/supplier.dart';
import 'package:flutter_app/features/supplier/presentation/cubit/supplier_cart_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ───────────────────────────────────────────────────────────────────────────── Vendor — Supplier
class SupplierDetailsScreen extends StatefulWidget {
  final Supplier? supplier;

  const SupplierDetailsScreen({super.key, this.supplier});

  @override
  State<SupplierDetailsScreen> createState() => _SupplierDetailsScreenState();
}

class _SupplierDetailsScreenState extends State<SupplierDetailsScreen> {
  final SupplierCartCubit _cartCubit = SupplierCartCubit();

  late final Supplier _supplier;

  @override
  void initState() {
    super.initState();
    _supplier = widget.supplier ?? SupplierData.demoSupplier;
  }

  @override
  void dispose() {
    _cartCubit.close();
    super.dispose();
  }

  void _add(String id) => _cartCubit.increment(id);

  void _increment(String id) => _cartCubit.increment(id);

  void _decrement(String id) => _cartCubit.decrement(id);

  void _goToCart() {
    final cartItems = _supplier.mainProducts
        .where((p) => (_cartCubit.state.quantities[p.id] ?? 0) > 0)
        .toList();

    context.push(
      AppRoutes.vendorCart,
      extra: VendorCartRouteData(
        cartItems: cartItems,
        initialQuantities: Map.from(_cartCubit.state.quantities),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupplierCartCubit, SupplierCartState>(
      bloc: _cartCubit,
      builder: (context, state) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              SecondAppHeader(
                title: 'Supplier Details',
                trailing: _buildCartAction(),
                trailingRightInset: 16,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 17, 32),
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

                      // ── About ─────────────────────────────────
                      _SectionTitle(
                        title: 'About Supplier',
                        style: GoogleFonts.roboto(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          height: 1,
                          letterSpacing: -0.18,
                          color: const Color(0xFF202020),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _supplier.aboutText,
                        style: GoogleFonts.roboto(
                          fontSize: 7,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF535353),
                          height: 12 / 7,
                          letterSpacing: -0.14,
                        ),
                      ),
                      const SizedBox(height: 22),

                      // ── Main Products heading ─────────────────
                      _SectionTitle(title: 'Main Products'),
                      const SizedBox(height: 13),

                      // ── 2-col product grid ────────────────────
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 19,
                              mainAxisSpacing: 13,
                              childAspectRatio: 156 / 232,
                            ),
                        itemCount: _supplier.mainProducts.length,
                        itemBuilder: (context, i) {
                          final product = _supplier.mainProducts[i];
                          final qty = state.quantities[product.id] ?? 0;
                          return VendorProductCard(
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
      ),
    );
  }

  Widget _buildCartAction() {
    return GestureDetector(
      onTap: _cartCubit.state.count > 0 ? _goToCart : null,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              color: Color(0xFF003A8A),
              size: 22,
            ),
          ),
          if (_cartCubit.state.count > 0)
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
                    _cartCubit.state.count > 99
                        ? '99+'
                        : '${_cartCubit.state.count}',
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

// ───────────────────────────────────────────────────────────────────────────── Supplier info card
class _SupplierInfoCard extends StatelessWidget {
  final Supplier supplier;
  const _SupplierInfoCard({required this.supplier});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.fromLTRB(0, 0, 14, 5),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 5, 0, 0),
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(
                'assets/solarimages/5dc175c533f86ed941b1004c6b373c14c68068d0.png',
                fit: BoxFit.contain,
                errorBuilder: (ctx, e, s) => const Icon(
                  Icons.business_rounded,
                  color: Color(0xFF003A8A),
                  size: 28,
                ),
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

// ───────────────────────────────────────────────────────────────────────────── Stats row
class _StatsRow extends StatelessWidget {
  final double rating;
  final int totalOrders;
  const _StatsRow({required this.rating, required this.totalOrders});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 19),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _StatCard(
            value: rating.toStringAsFixed(1),
            label: 'Rating',
            valueColor: const Color(0xFF003A8A),
          ),
          const SizedBox(width: 11),
          _StatCard(
            value: '$totalOrders+',
            label: 'Orders',
            valueColor: const Color(0xFF003A8A),
          ),
        ],
      ),
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
      width: 152,
      height: 52,
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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

// ───────────────────────────────────────────────────────────────────────────── Section title
class _SectionTitle extends StatelessWidget {
  final String title;
  final TextStyle? style;

  const _SectionTitle({required this.title, this.style});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style:
          style ??
          GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1A1A),
            letterSpacing: -0.2,
          ),
    );
  }
}
