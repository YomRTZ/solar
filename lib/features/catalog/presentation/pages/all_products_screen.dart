import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/core/widgets/app_catalog_card.dart';
import 'package:flutter_app/features/catalog/data/datasources/catalog_data.dart';
import 'package:flutter_app/features/catalog/domain/entities/catalog_product.dart';
import 'package:flutter_app/features/catalog/presentation/cubit/catalog_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  // Search
  final TextEditingController _searchController = TextEditingController();
  final CatalogCubit _catalogCubit = CatalogCubit();

  int get _cartCount => _catalogCubit.state.cartCount;

  List<CatalogProduct> get _filtered {
    if (_catalogCubit.state.query.isEmpty) return CatalogData.products;
    final q = _catalogCubit.state.query.toLowerCase();
    return CatalogData.products
        .where(
          (p) =>
              p.name.toLowerCase().contains(q) ||
              p.subtitle.toLowerCase().contains(q),
        )
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _catalogCubit.close();
    super.dispose();
  }

  void _addToRFQ(String id) => _catalogCubit.increment(id);

  void _increment(String id) => _catalogCubit.increment(id);

  void _decrement(String id) => _catalogCubit.decrement(id);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatalogCubit, CatalogState>(
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
          backgroundColor: Colors.white,
          extendBodyBehindAppBar: true,
          body: Column(
            children: [
              _buildHeader(context),
              _buildSearchBar(),
              Expanded(child: _buildGrid()),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      height: top + 133,
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
            // Back button
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: SvgPicture.asset(
                'assets/icons/arrow-narrow-left.svg',
                width: 24,
                height: 24,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 12),

            // Title
            Expanded(
              child: Text(
                'All Products',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.4,
                ),
              ),
            ),

            // Cart icon with badge
            GestureDetector(
              onTap: _cartCount > 0 ? () => _showCartSummary(context) : null,
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

  // ── Search bar ─────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 21, 17, 14),
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
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
          const Icon(Icons.search, color: Color(0xFF6C7278), size: 22),
          const SizedBox(width: 11),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: _catalogCubit.updateQuery,
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: const Color(0xFF202020),
              ),
              decoration: InputDecoration(
                hintText: 'Search Product...',
                hintStyle: GoogleFonts.roboto(
                  fontSize: 14,
                  color: const Color(0xFF9E9E9E),
                ),
                border: InputBorder.none,
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
              child: const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(Icons.clear, color: Color(0xFF6C7278), size: 18),
              ),
            ),
        ],
      ),
    );
  }

  // ── 2-column grid ─────────────────────────────────────────
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
                color: Colors.grey[500],
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
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        // 217 / 156 ≈ 1.391 — keep exact card ratio
        childAspectRatio: 156 / 217,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        final qty = _catalogCubit.state.rfqQuantities[product.id] ?? 0;

        // Reusable AppCatalogCard
        return AppCatalogCard(
          imagePath: product.imagePath,
          name: product.name,
          subtitle: product.subtitle,
          price: product.price,
          quantity: qty,
          onAdd: () => _addToRFQ(product.id),
          onIncrement: () => _increment(product.id),
          onDecrement: () => _decrement(product.id),
        );
      },
    );
  }

  // ── Cart summary bottom sheet ─────────────────────────────
  void _showCartSummary(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        final addedProducts = CatalogData.products
            .where((p) => (_catalogCubit.state.rfqQuantities[p.id] ?? 0) > 0)
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
              ...addedProducts.map(
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
                        'x${_catalogCubit.state.rfqQuantities[p.id]}',
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
                height: 44,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003D82),
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
