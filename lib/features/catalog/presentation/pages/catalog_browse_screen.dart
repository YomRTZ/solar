import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:flutter_app/features/catalog/presentation/widgets/catalog_category_card.dart';
import 'package:flutter_app/features/catalog/presentation/widgets/catalog_product_card.dart';
import 'package:flutter_app/features/catalog/data/datasources/catalog_data.dart';
import 'package:flutter_app/features/catalog/domain/entities/catalog_category.dart';
import 'package:flutter_app/features/catalog/domain/entities/catalog_product.dart';
import 'package:flutter_app/features/catalog/presentation/cubit/catalog_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CatalogBrowseScreen extends StatefulWidget {
  const CatalogBrowseScreen({super.key});

  @override
  State<CatalogBrowseScreen> createState() => _CatalogBrowseScreenState();
}

class _CatalogBrowseScreenState extends State<CatalogBrowseScreen> {
  final TextEditingController _searchController = TextEditingController();

  // CatalogCubit is provided by VendorMainScreen's BlocProvider so that
  // cart state is shared between Home and AllProducts.  Fall back to creating
  // a local one when this screen is pushed independently (e.g. in tests).
  CatalogCubit get _catalogCubit => context.read<CatalogCubit>();

  List<CatalogProduct> get _filteredProducts {
    final q = _catalogCubit.state.query.toLowerCase();
    if (q.isEmpty) return CatalogData.products;
    return CatalogData.products
        .where((p) => p.name.toLowerCase().contains(q))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _add(String id) => _catalogCubit.increment(id);
  void _increment(String id) => _catalogCubit.increment(id);
  void _decrement(String id) => _catalogCubit.decrement(id);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatalogCubit, CatalogState>(
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
              _buildHeader(context, state),
              _buildSearchBar(state),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 0, 17, 0),
                        child: _buildCategoryGrid(),
                      ),
                      const SizedBox(height: 28),
                      Padding(
                        padding: const EdgeInsets.only(left: 12, right: 15),
                        child: _buildBanner(context),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 17, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'All Products',
                              style: GoogleFonts.roboto(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF23201C),
                                height: 1,
                              ),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  context.push(AppRoutes.vendorAllProducts),
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
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 17, 0),
                        child: _buildProductGrid(state),
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

  Widget _buildHeader(BuildContext context, CatalogState state) {
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
      child: Stack(
        children: [
          // Logo
          Positioned(
            top: top + 51,
            left: 148,
            right: 148,
            bottom: 11,
            child: Image.asset(
              'assets/images/solartradeshub_logo.png',
              fit: BoxFit.contain,
              errorBuilder: (ctx, err, st) => const Icon(
                Icons.wb_sunny_rounded,
                color: Colors.amber,
                size: 48,
              ),
            ),
          ),

          // Notification bell
          Positioned(
            bottom: 20,
            right: 22,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Image.asset(
                  'assets/icons/ic_notification.png',
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

  Widget _buildSearchBar(CatalogState state) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 21, 17, 14),
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFEDF1F3)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3DE4E5E7),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          SvgPicture.asset('assets/icons/ic_search.svg', width: 24, height: 24),
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
          if (state.query.isNotEmpty)
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

  Widget _buildCategoryGrid() {
    return Column(
      children: [
        _buildCategoryRow(CatalogData.homeCategories.take(4)),
        const SizedBox(height: 23),
        _buildCategoryRow(CatalogData.homeCategories.skip(4).take(4)),
      ],
    );
  }

  Widget _buildCategoryRow(Iterable<CatalogCategory> categories) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: categories.map((cat) {
        return CatalogCategoryCard(
          iconPath: cat.iconPath,
          label: cat.name,
          width: 74,
          height: 71,
          iconContainerSize: 28,
          compact: true,
          onTap: () {
            if (cat.id == 'cat_more') {
              context.push(AppRoutes.vendorCategories);
            } else {
              context.push(AppRoutes.vendorAllProducts);
            }
          },
        );
      }).toList(),
    );
  }

  Widget _buildBanner(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.vendorAllProducts),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: double.infinity,
          height: 104,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/solarimages/solar_panel_field_photo.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: [0, 0.7616],
                      colors: [Color(0xB3003A8A), Color(0xB3000F24)],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 13,
                top: 17,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Premium!',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      'Solar Panels',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'For a cleaner tomorrow',
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductGrid(CatalogState state) {
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

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 12,
        childAspectRatio: 156 / 232,
      ),
      itemCount: products.length,
      itemBuilder: (context, i) {
        final product = products[i];
        final qty = state.cartQuantities[product.id] ?? 0;

        return CatalogProductCard(
          imagePath: product.imagePath,
          name: product.name,
          price: product.price,
          quantity: qty,
          onTap: () => context.push(AppRoutes.supplierDetails),
          onAdd: () => _add(product.id),
          onIncrement: () => _increment(product.id),
          onDecrement: () => _decrement(product.id),
          showBrandMark: i < 2,
        );
      },
    );
  }
}
