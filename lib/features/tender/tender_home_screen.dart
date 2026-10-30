import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../app/routing/app_routes.dart';
import '../../core/widgets/tender_category_card.dart';
import '../../core/widgets/tender_product_card.dart';
import '../../data/tender_data.dart';
import '../../models/catalog_product.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Tender Home Screen
// Mirrors the layout of home_screen.dart:
//  • Dark-gradient header (logo + bell)
//  • Search bar
//  • Four-column, two-row category grid
//  • Promo banner
//  • "All Products" section heading + 2-col product grid
// ─────────────────────────────────────────────────────────────────────────────
class TenderHomeScreen extends StatefulWidget {
  const TenderHomeScreen({super.key});

  @override
  State<TenderHomeScreen> createState() => _TenderHomeScreenState();
}

class _TenderHomeScreenState extends State<TenderHomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // RFQ cart: productId → quantity
  final Map<String, int> _rfqCart = {};

  List<CatalogProduct> get _filteredProducts {
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
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Search bar ────────────────────────────
                    _buildSearchBar(),
                    const SizedBox(height: 16),

                    // ── 4-column, 2-row category grid ────────
                    _buildCategoryGrid(),
                    const SizedBox(height: 18),

                    // ── Promo banner ──────────────────────────
                    _buildBanner(context),
                    const SizedBox(height: 20),

                    // ── "All Products" heading ────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'All Products',
                          style: GoogleFonts.roboto(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                            color: const Color(0xFF23201C),
                            height: 1,
                            letterSpacing: 0,
                          ),
                        ),
                        GestureDetector(
                          onTap: () =>
                              context.push(AppRoutes.tenderAllProducts),
                          child: Text(
                            'See all',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF003A8A),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    // ── 2-col product grid ────────────────────
                    _buildProductGrid(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header: same dark gradient as home_screen ──────────────
  Widget _buildHeader(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      height: top + 100,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF003A8A), Color(0xFF000F24)],
        ),
      ),
      child: Stack(
        children: [
          // Logo centred in the visible 100 px area
          Positioned(
            top: top + 18,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/images/a_clean_high_resolution_vector_like_logo_image_on.png',
                width: 56,
                height: 56,
                fit: BoxFit.contain,
                errorBuilder: (ctx, err, st) => const Icon(
                  Icons.wb_sunny_rounded,
                  color: Colors.amber,
                  size: 48,
                ),
              ),
            ),
          ),

          // Notification bell
          Positioned(
            top: top + 30,
            right: 16,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Image.asset(
                  'assets/icons/image_1374.png',
                  width: 28,
                  height: 28,
                  errorBuilder: (ctx, err, st) => const Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF3B30),
                      shape: BoxShape.circle,
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

  // ── Search bar ────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Container(
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

  // ── 4-column, 2-row category grid ────────────────────────
  Widget _buildCategoryGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 3,
        mainAxisSpacing: 12,
        mainAxisExtent: 71,
      ),
      itemCount: TenderData.homeCategories.length,
      itemBuilder: (context, i) {
        final cat = TenderData.homeCategories[i];
        return Center(
          child: TenderCategoryCard(
            iconPath: cat.iconPath,
            label: cat.name,
            width: 74,
            height: 71,
            iconContainerSize: 28,
            compact: true,
            onTap: () {
              if (cat.id == 'cat_more') {
                context.push(AppRoutes.tenderCategories);
              } else {
                context.push(AppRoutes.tenderAllProducts);
              }
            },
          ),
        );
      },
    );
  }

  // ── Promo banner ─────────────────────────────────────────
  Widget _buildBanner(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.tenderAllProducts),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Background image
            SizedBox(
              width: double.infinity,
              height: 120,
              child: Image.asset(
                'assets/solarimages/40e6eb83a0b81c11a222c2e30e9a248524bdf315.jpg',
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, st) =>
                    Container(height: 120, color: const Color(0xFF003A8A)),
              ),
            ),

            // Dark overlay
            Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withValues(alpha: 0.65),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            // Text
            Positioned(
              left: 16,
              top: 0,
              bottom: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Premium!',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      color: const Color(0xFFFFFFFF),
                      height: 1,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Solar Panels',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      color: const Color(0xFFFFFFFF),
                      height: 1,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'For a cleaner tomorrow',
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                      color: const Color(0xFFFFFFFF),
                      height: 1,
                      letterSpacing: 0,
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

  // ── 2-column product grid ────────────────────────────────
  Widget _buildProductGrid() {
    final products = _filteredProducts;

    if (products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Text(
            'No products found',
            style: GoogleFonts.roboto(fontSize: 15, color: Colors.grey[400]),
          ),
        ),
      );
    }

    // Use a GridView inside a ShrinkWrap so it plays nicely inside
    // the outer SingleChildScrollView.
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
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

        return TenderProductCard(
          imagePath: product.imagePath,
          name: product.name,
          price: product.price,
          quantity: qty,
          onTap: () => context.push(AppRoutes.tenderSupplierDetails),
          onAdd: () => _add(product.id),
          onIncrement: () => _increment(product.id),
          onDecrement: () => _decrement(product.id),
        );
      },
    );
  }
}
