import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_app/core/widgets/second_app_header.dart';
import 'package:flutter_app/features/vendor/presentation/widgets/vendor_product_card.dart';
import 'package:flutter_app/features/vendor/data/datasources/vendor_data.dart';
import 'package:flutter_app/features/catalog/domain/entities/catalog_product.dart';
import 'package:flutter_app/features/vendor/presentation/widgets/vendor_compare_sheet.dart';
import 'package:flutter_app/features/vendor/presentation/widgets/vendor_product_detail_sheet.dart';

// ───────────────────────────────────────────────────────────────────────────── Vendor All
class VendorAllProductsScreen extends StatefulWidget {
  const VendorAllProductsScreen({super.key});

  @override
  State<VendorAllProductsScreen> createState() =>
      _VendorAllProductsScreenState();
}

class _VendorAllProductsScreenState extends State<VendorAllProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // RFQ cart: productId → quantity
  final Map<String, int> _rfqCart = {};

  // Compare list (max 2)
  final List<CatalogProduct> _compareList = [];
  static const int _maxCompare = 2;

  int get _cartCount => _rfqCart.values.fold(0, (sum, qty) => sum + qty);

  List<CatalogProduct> get _filtered {
    if (_searchQuery.isEmpty) return VendorData.products;
    final q = _searchQuery.toLowerCase();
    return VendorData.products
        .where((p) => p.name.toLowerCase().contains(q))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── Cart mutations ─────────────────────────────────────────
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

  // ── Compare mutations ──────────────────────────────────────
  void _addToCompare(CatalogProduct product) {
    setState(() {
      if (_compareList.length >= _maxCompare) {
        _compareList.removeAt(0); // slide out oldest if full
      }
      if (!_compareList.any((p) => p.id == product.id)) {
        _compareList.add(product);
      }
    });
  }

  // ── Sheet launchers ────────────────────────────────────────

  // Opens the product detail sheet
  void _openDetailSheet(BuildContext context, CatalogProduct product) {
    // Ensure at least qty 1 when opening the sheet
    if ((_rfqCart[product.id] ?? 0) == 0) {
      setState(() => _rfqCart[product.id] = 1);
    }

    VendorProductDetailSheet.show(
      context: context,
      product: product,
      quantity: _rfqCart[product.id] ?? 1,
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
      products: List.unmodifiable(_compareList),
      rfqCartCounts: Map.unmodifiable(_rfqCart),
      cartCount: _cartCount,
      onAddToRFQ: (p) {
        setState(() => _rfqCart[p.id] = (_rfqCart[p.id] ?? 0) + 1);
        Navigator.pop(context);
      },
    );
  }

  // ── Build ──────────────────────────────────────────────────
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
              title: 'All Products',
              trailing: _buildCartAction(context),
            ),
            _buildSearchBar(),
            const SizedBox(height: 12),
            Expanded(child: _buildGrid()),
          ],
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

  // ── Search bar ────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
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
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v),
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
          if (_searchQuery.isNotEmpty)
            GestureDetector(
              onTap: () => setState(() {
                _searchController.clear();
                _searchQuery = '';
              }),
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
        childAspectRatio: 156 / 217,
      ),
      itemCount: products.length,
      itemBuilder: (context, i) {
        final product = products[i];
        final qty = _rfqCart[product.id] ?? 0;

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
            .where((p) => (_rfqCart[p.id] ?? 0) > 0)
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
                        'x${_rfqCart[p.id]}',
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
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003A8A),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Submit RFQ',
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
