import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/widgets/tender_product_card.dart';
import '../../data/tender_data.dart';
import '../../models/catalog_product.dart';
import 'tender_compare_sheet.dart';
import 'tender_product_detail_sheet.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Tender All Products Screen
//
// Flow:
//  1. Tap a product card → TenderProductDetailSheet opens
//     • Qty stepper, spec table, "Add to Compare" + "Add to RFQ"
//  2. Tap "Add to Compare" inside detail sheet
//     → detail sheet closes, TenderCompareSheet opens
//  3. Tap "Add to RFQ" in either sheet → adds to cart, closes sheet
// ─────────────────────────────────────────────────────────────────────────────
class TenderAllProductsScreen extends StatefulWidget {
  const TenderAllProductsScreen({super.key});

  @override
  State<TenderAllProductsScreen> createState() =>
      _TenderAllProductsScreenState();
}

class _TenderAllProductsScreenState extends State<TenderAllProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // RFQ cart: productId → quantity
  final Map<String, int> _rfqCart = {};

  // Compare list (max 2)
  final List<CatalogProduct> _compareList = [];
  static const int _maxCompare = 2;

  int get _cartCount =>
      _rfqCart.values.fold(0, (sum, qty) => sum + qty);

  List<CatalogProduct> get _filtered {
    if (_searchQuery.isEmpty) return TenderData.products;
    final q = _searchQuery.toLowerCase();
    return TenderData.products
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

  /// Opens the product detail sheet. Passes callbacks so the sheet can
  /// trigger the compare sheet or mutate cart without knowing the screen.
  void _openDetailSheet(BuildContext context, CatalogProduct product) {
    // Ensure at least qty 1 when opening the sheet
    if ((_rfqCart[product.id] ?? 0) == 0) {
      setState(() => _rfqCart[product.id] = 1);
    }

    TenderProductDetailSheet.show(
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
    TenderCompareSheet.show(
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
            _buildHeader(context),
            _buildSearchBar(),
            const SizedBox(height: 12),
            Expanded(child: _buildGrid()),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      height: top + 64,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF003A8A), Color(0xFF000F24)],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, top + 16, 16, 0),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back,
                  color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'All Products',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: -0.3,
                ),
              ),
            ),

            // Cart icon with badge
            GestureDetector(
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
            ),
          ],
        ),
      ),
    );
  }

  // ── Search bar ────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          const Icon(Icons.search, color: Color(0xFF9E9E9E), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v),
              style: GoogleFonts.roboto(
                  fontSize: 14, color: const Color(0xFF202020)),
              decoration: InputDecoration(
                hintText: 'Search Product...',
                hintStyle: GoogleFonts.roboto(
                    fontSize: 14, color: const Color(0xFF9E9E9E)),
                border: InputBorder.none,
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
              child: const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(Icons.clear, color: Color(0xFF9E9E9E), size: 18),
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
                  color: Colors.grey[400]),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 156 / 220,
      ),
      itemCount: products.length,
      itemBuilder: (context, i) {
        final product = products[i];
        final qty = _rfqCart[product.id] ?? 0;

        return TenderProductCard(
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
        );      },
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
        final added = TenderData.products
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
                  Text('RFQ Cart',
                      style: GoogleFonts.inter(
                          fontSize: 16, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Text(
                    '$_cartCount item${_cartCount == 1 ? '' : 's'}',
                    style: GoogleFonts.roboto(
                        fontSize: 13, color: const Color(0xFF6C7278)),
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
                        child: Text(p.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.roboto(
                                fontSize: 13,
                                fontWeight: FontWeight.w500)),
                      ),
                      const SizedBox(width: 8),
                      Text('x${_rfqCart[p.id]}',
                          style: GoogleFonts.roboto(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF003A8A),
                          )),
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
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('Submit RFQ',
                      style: GoogleFonts.inter(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
