import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:flutter_app/app/routing/route_data.dart';
import 'package:flutter_app/core/widgets/second_app_header.dart';
import 'package:flutter_app/features/vendor/presentation/widgets/vendor_product_card.dart';
import 'package:flutter_app/features/vendor/data/datasources/vendor_data.dart';
import 'package:flutter_app/features/catalog/domain/entities/catalog_product.dart';
import 'package:flutter_app/features/vendor/presentation/widgets/vendor_compare_sheet.dart';
import 'package:flutter_app/features/vendor/presentation/widgets/vendor_product_detail_sheet.dart';
import 'package:flutter_app/features/vendor/presentation/cubit/vendor_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ───────────────────────────────────────────────────────────────────────────── Vendor All
class VendorAllProductsScreen extends StatefulWidget {
  const VendorAllProductsScreen({super.key});

  @override
  State<VendorAllProductsScreen> createState() =>
      _VendorAllProductsScreenState();
}

class _VendorAllProductsScreenState extends State<VendorAllProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  static const int _maxCompare = 2;

  // Use the shared VendorCatalogCubit provided by VendorMainScreen so the
  // cart is in sync with VendorHomeScreen.  A local fallback is created when
  // this screen is pushed standalone (e.g. directly via go_router).
  VendorCatalogCubit? _localCubit;
  VendorCatalogCubit get _catalogCubit {
    try {
      return context.read<VendorCatalogCubit>();
    } catch (_) {
      _localCubit ??= VendorCatalogCubit();
      return _localCubit!;
    }
  }

  int get _cartCount => _catalogCubit.state.cartCount;

  List<CatalogProduct> get _filtered {
    if (_catalogCubit.state.query.isEmpty) return VendorData.products;
    final q = _catalogCubit.state.query.toLowerCase();
    return VendorData.products
        .where((p) => p.name.toLowerCase().contains(q))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _localCubit?.close();
    super.dispose();
  }

  // ── Cart mutations ─────────────────────────────────────────
  void _add(String id) => _catalogCubit.increment(id);

  void _increment(String id) => _catalogCubit.increment(id);

  void _decrement(String id) => _catalogCubit.decrement(id);

  // ── Compare mutations ──────────────────────────────────────
  void _addToCompare(CatalogProduct product) {
    _catalogCubit.addToCompare(product, limit: _maxCompare);
  }

  // ── Sheet launchers ────────────────────────────────────────

  // Opens the product detail sheet
  void _openDetailSheet(BuildContext context, CatalogProduct product) {
    // Ensure at least qty 1 when opening the sheet
    _catalogCubit.ensureOne(product.id);

    VendorProductDetailSheet.show(
      context: context,
      product: product,
      quantity: _catalogCubit.state.cartQuantities[product.id] ?? 1,
      cartCount: _cartCount,
      onIncrement: () {
        _increment(product.id);
        // Dismiss and reopen with updated state
        Navigator.pop(context);
        _openDetailSheet(context, product);
      },
      onDecrement: () {
        _decrement(product.id);
        Navigator.pop(context);
        _openDetailSheet(context, product);
      },
      onAddToRFQ: () {
        // qty already set; just close the sheet
        Navigator.pop(context);
      },
      onAddToCompare: () {
        _addToCompare(product);
        // Close detail sheet then open compare sheet
        Navigator.pop(context);
        _openCompareSheet(context);
      },
    );
  }

  void _openCompareSheet(BuildContext context) {
    VendorCompareSheet.show(
      context: context,
      products: _catalogCubit.state.comparedProducts,
      rfqCartCounts: _catalogCubit.state.cartQuantities,
      cartCount: _cartCount,
      onAddToRFQ: (p) {
        _catalogCubit.increment(p.id);
        Navigator.pop(context);
      },
    );
  }

  // ── Build ──────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VendorCatalogCubit, VendorCatalogState>(
      bloc: _catalogCubit,
      builder: (context, state) => AnnotatedRegion<SystemUiOverlayStyle>(
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
                title: 'All Products',
                trailing: _buildCartAction(context),
                trailingRightInset: 16,
              ),
              _buildSearchBar(),
              Expanded(child: _buildGrid()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartAction(BuildContext context) {
    return GestureDetector(
      onTap: _cartCount > 0 ? () => _showCartSheet(context) : null,
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

  // ── Search bar ────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 21, 17, 14),
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFEDF1F3), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3DE4E5E7),
            blurRadius: 2,
            offset: Offset(0, 1),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          SvgPicture.asset('assets/icons/search.svg', width: 24, height: 24),
          const SizedBox(width: 11),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: _catalogCubit.updateQuery,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1A1C1E),
                height: 1.4,
                letterSpacing: -0.14,
              ),
              decoration: InputDecoration(
                hintText: 'Search Product...',
                hintStyle: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1A1C1E),
                  height: 1.4,
                  letterSpacing: -0.14,
                ),
                filled: true,
                fillColor: Colors.transparent,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (_catalogCubit.state.query.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchController.clear();
                _catalogCubit.updateQuery('');
              },
              child: const Icon(
                Icons.clear,
                color: Color(0xFF6C7278),
                size: 18,
              ),
            ),
        ],
      ),
    );
  }

  // ── 2-column product grid ─────────────────────────────────
  Widget _buildGrid() {
    final products = _filtered;

    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 60, color: Colors.grey[300]),
            const SizedBox(height: 12),
            Text(
              'No products found',
              style: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 12,
        childAspectRatio: 156 / 232,
      ),
      itemCount: products.length,
      itemBuilder: (context, i) {
        final product = products[i];
        final qty = _catalogCubit.state.cartQuantities[product.id] ?? 0;

        return VendorProductCard(
          imagePath: product.imagePath,
          name: product.name,
          price: product.price,
          quantity: qty,
          // Card tap → detail sheet
          onTap: () => _openDetailSheet(context, product),
          // "Add to RFQ" button on card still works directly
          onAdd: () => _add(product.id),
          onIncrement: () => _increment(product.id),
          onDecrement: () => _decrement(product.id),
          showBrandMark: i < 2,
        );
      },
    );
  }

  // ── Cart summary sheet ────────────────────────────────────
  void _showCartSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final added = VendorData.products
            .where((p) => (_catalogCubit.state.cartQuantities[p.id] ?? 0) > 0)
            .toList();

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'RFQ Cart',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '$_cartCount item${_cartCount == 1 ? '' : 's'}',
                    style: GoogleFonts.roboto(
                      fontSize: 13,
                      color: const Color(0xFF6C7278),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...added.map(
                (p) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          p.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'x${_catalogCubit.state.cartQuantities[p.id]}',
                        style: GoogleFonts.roboto(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF003A8A),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    // Navigate to full RFQ cart screen
                    final cartState = _catalogCubit.state;
                    final cartItems = VendorData.products
                        .where((p) => (cartState.cartQuantities[p.id] ?? 0) > 0)
                        .toList();
                    context.push(
                      AppRoutes.vendorCart,
                      extra: VendorCartRouteData(
                        cartItems: cartItems,
                        initialQuantities: Map<String, int>.from(
                          cartState.cartQuantities,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003A8A),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'View RFQ Cart',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
